# Pushing Data to ActivityInfo

---

@title[Who is this talk for? - 1/3]
## Who is this talk for?
This is not a general talk on APIs. It will go into technical detail on the _ActivityInfo_ API.

However, anyone with some technical background should be able to follow along.

---

@title[Who is this talk for? - 2/3]
## Who is this talk for?

This talk is intended for:
- Developers in organisations using ActivityInfo on applications which need to inter-operate with ActivityInfo
- Members of organisations with developers capable of utilising REST APIs

---

@title[Who is this talk for? - 3/3]
## Not for you?

You can still use our new Importer!

Beta available here:
\\\ INSERT BETA LINK ///

---

@title[What is the aim of this talk?]
## What is the aim of this talk?

- Use the ActivityInfo API to create, update and delete data in ActivityInfo
- Demonstrate how to push external data from multiple sources
- Understand how you can use the ActivityInfo API to extend your applications

---
@title[Learning Outcomes]
## Learning Outcomes
From this presentation, you should understand:
- How to create, update and delete a Form Record
- How to perform multiple operations in a batch
- The basic concepts needed to inter-operate with ActivityInfo via the API

---
@title[Topics]
## Topics
- Review of Data Model
- Update Form Record Request
- Create a Form Record
- Update a Form Record
- Delete a Form Record
- Batched Updates to Form Records
- Example 1: Import Legacy Data (using R)
- Example 2: Integrating Different Databases (using R)

---

@title[Data Model Review]
## Data Model Review

To prepare, let's review:
- Forms and Sub-Forms
- Form Fields
- Form and Sub-Form Records

---

# Form

@snap[east]
@fa[file fa-5x]
@snapend

@snap[south]
@fa[arrow-down]
@snapend

+++
@title[Form Definition]
## @color[#00CF79](Form)

- Organises the various data to be collected, and how they link together
- Composed of one or more Fields which represent a type of data to be collected

+++
@title[Form in UI - Design]
![Form in UI - Design](activityinfo/api/pushing-data/img/form.png)

+++
@title[Form in UI - Data Entry]
![Form in UI - Data Entry](activityinfo/api/pushing-data/img/form-data-entry.png)

+++
@title[Form Schema Request]
## Query for Form Schema
Generic Request for Form Schema:

```http
GET https://activityinfo.org/resources/form/{formId}/schema
```

+++
@title[Example 1]
## Example 1
For this example, we will send the following request:

```http
GET https://activityinfo.org/resources/form/a2145507922/schema
```

+++
@title[Form Schema Response]
```json
{
    "id": "a2145507921",
    "schemaVersion": 1,
    "databaseId": "d0000009909",
    "label": "Ongoing Projects",
    "elements": [
        {
            "id": "i1246439317",
            "code": null,
            "label": "Project Name",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "FREE_TEXT",
            "typeParameters": {}
        },
        ...
    ]
}
```

@[2](Form Id)
@[3](Form Schema Version)
@[4](Database Id)
@[5](Form Label/Name)
@[6-19](Form Elements i.e. Fields)

+++
@title[Form Schema Definition]
## Form Schema Definition

```
Form: {
	"id": string,
	"schemaVersion": int,
	"databaseId": string,
	"label": string,
	"elements": [ FormField ]
}
```

---

# Sub-Form

@snap[east]
@fa[level-down fa-5x] @fa[file fa-5x]
@snapend

@snap[south]
@fa[arrow-down]
@snapend

+++
@title[Sub-Form Definition]
## @color[#00CF79](Sub-Form)

- Contained within a Parent Form
- Submit multiple entries within a single Form Record (e.g. Monthly)
- Reference Fields connect the Parent Form and Sub-Form

+++
@title[Sub-Form in UI]
![Sub-Form in UI](activityinfo/api/data-model/img/subform.png)

+++
@title[Sub-Form in Context]
![Sub-Form in Context](activityinfo/api/data-model/img/subform-context.png)

+++
@title[Query for Sub-Form Schema]
## Query for Sub-Form Schema
We can use the same endpoint for retrieving a Sub-Form Schema:

```http
GET https://activityinfo.org/resources/form/{subFormId}/schema
```
+++
@title[Example 8.1: Parent Form Schema Request]
## Example 8.1: Parent Form Schema
To find our Sub-Form Id, we retrieve the Parent Form's schema first:

```http
GET https://activityinfo.org/resources/form/a2145507924/schema
```

+++
@title[Parent Form Schema Response]
## Parent Form

```json
{
    "id": "a2145507924",
    "schemaVersion": 1,
    "databaseId": "d0000009909",
    "label": "Project Expenses",
    "elements": [
        {
            "id": "i0649125506",
            "code": "proj",
            "label": "Project Name",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "FREE_TEXT",
            "typeParameters": {}
        },
        {
            "id": "i0908831014",
            "code": "code",
            "label": "Project Code",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "FREE_TEXT",
            "typeParameters": {}
        },
        {
            "id": "a21455079240000000007",
            "code": "partner",
            "label": "Partner",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": true,
            "type": "reference",
            "typeParameters": {
                "cardinality": "single",
                "range": [
                    {
                        "formId": "P0000009909"
                    }
                ]
            }
        },
        {
            "id": "i2093438408",
            "code": null,
            "label": "Expenses",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "subform",
            "typeParameters": {
                "formId": "cjmhib4oy1"
            }
        }
    ]
}
```

@[47-59](Our Sub-Form Reference Field)
@[55](Has type `subform`)
@[57](Our Expenses Sub-Form Id is `cjmhib4oy1`)

+++
@title[Example 8.2: Sub-Form Schema]
## Example 8.2: Sub-Form Schema

Using our Sub-Form Id, we will send the following request to find our Sub-Form Schema:

```http
GET https://activityinfo.org/resources/form/cjmhib4oy1/schema
```

+++
@title[Sub-Form Schema Response]
## Sub-Form

```json
{
    "id": "cjmhib4oy1",
    "schemaVersion": 0,
    "databaseId": "d0000009909",
    "label": "Expenses",
    "parentFormId": "a2145507924",
    "subFormKind": "repeating",
    "elements": [
        {
            "id": "i0337573943",
            "code": "descrip",
            "label": "Description of Expense",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "NARRATIVE"
        },
        {
            "id": "i0701024476",
            "code": "cost",
            "label": "Cost",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "quantity",
            "typeParameters": {
                "units": "$",
                "aggregation": "SUM"
            }
        }
    ]
}
```

@[2-5](Sub-Forms share the same basic attributes as Forms)
@[6](Includes an extra `parentFormId` attribute...)
@[7](Also includes `subFormKind` giving the reporting interval of the Sub-Form entries)
@[8](Form Fields appear as `elements` in the same way as Forms)

+++
@title[Sub-Form Schema Definition]
## Sub-Form Schema

```
Form: {
	"id": string,
	"schemaVersion": int,
	"databaseId": string,
	"label": string,
	"parentFormId": string,
	"subFormKind": string,
	"elements": [ FormField ]
}
```

@[7](Enum choice of `{ 'repeating', 'daily', 'weekly', 'biweekly' 'monthly' }`)

---

# Form Field

@snap[east]
@fa[th-list fa-5x]
@snapend

@snap[south]
@fa[arrow-down]
@snapend

+++
@title[Form Field Definition]
## @color[#00CF79](Field)

- Represents a specific type of data to be collected
- Different set of properties depending on the Field Type

+++
@title[Form Field in UI - Design]
![Form Field in UI - Design](activityinfo/api/data-model/img/field.png)

+++
@title[Form Field in Context]
![Form Field in Context](activityinfo/api/data-model/img/field-context.png)

+++
@title[Form Field Request]
## Query for Form Field
Form Field is defined within a Form Schema. Therefore we use a generic request for Form Schema:

```http
GET https://activityinfo.org/resources/form/{formId}/schema
```

+++
@title[Example 3]
## Example 3

For this example, we will send the following request:

```http
GET https://activityinfo.org/resources/form/a1234567890/schema
```

+++
@title[Form Field Response]
```json
{
    "id": "a2145507922",
    "schemaVersion": 1,
    "databaseId": "d0000009909",
    "label": "Field Types",
    "elements": [
        {
            "id": "a21455079220000000007",
            "code": "partner",
            "label": "Partner",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": true,
            "type": "reference",
            "typeParameters": {
                "cardinality": "single",
                "range": [
                    {
                        "formId": "P0000009909"
                    }
                ]
            }
        },
        {
            "id": "i0596827260",
            "code": null,
            "label": "Serial Number",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "serial",
            "typeParameters": {
                "prefixFormula": "LLL000",
                "digits": 5
            }
        },
        {
            "id": "i1628839564",
            "code": null,
            "label": "Quantity",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "quantity",
            "typeParameters": {
                "units": "households",
                "aggregation": "SUM"
            }
        },
        {
            "id": "i2010895222",
            "code": null,
            "label": "Text",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "FREE_TEXT",
            "typeParameters": {}
        },
        {
            "id": "i2003200244",
            "code": null,
            "label": "Multi-line text",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "NARRATIVE"
        },
        {
            "id": "i0747756921",
            "code": null,
            "label": "Date",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "date"
        },
        {
            "id": "Q0290875264",
            "code": null,
            "label": "Which options apply?",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "enumerated",
            "typeParameters": {
                "cardinality": "multiple",
                "presentation": "automatic",
                "values": [
                    {
                        "id": "t0290490515",
                        "label": "Option 1"
                    },
                    {
                        "id": "t0291067638",
                        "label": "Option 2"
                    }
                ]
            }
        },
        {
            "id": "Q0225083202",
            "code": null,
            "label": "Which choice would you choose?",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "enumerated",
            "typeParameters": {
                "cardinality": "single",
                "presentation": "automatic",
                "values": [
                    {
                        "id": "t0226237449",
                        "label": "Option 1"
                    },
                    {
                        "id": "t0225275577",
                        "label": "Option 2"
                    }
                ]
            }
        },
        {
            "id": "i0583669177",
            "code": null,
            "label": "Geographic point",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "geopoint"
        },
        {
            "id": "i0405530436",
            "code": null,
            "label": "Barcode",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "barcode"
        },
        {
            "id": "i0856840896",
            "code": null,
            "label": "Image",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "attachment",
            "typeParameters": {
                "cardinality": "single",
                "kind": "image"
            }
        },
        {
            "id": "i0795281072",
            "code": null,
            "label": "Attachments",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "attachment",
            "typeParameters": {
                "cardinality": "single",
                "kind": "attachment"
            }
        },
        {
            "id": "i1380676524",
            "code": null,
            "label": "Calculated",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "calculated",
            "typeParameters": {
                "formula": "[Quantity] * 2"
            }
        }
    ]
}
```
@[6-15](We will focus on the `elements` property of the Form schema...)

---
@title[Form Records]
# Form
# Records

@snap[east]
@fa[file-text fa-5x]
@snapend

@snap[south]
@fa[arrow-down]
@snapend

+++
@title[Form Records Definition]
## @color[#00CF79](Form Records)

- Created when a User submits an entry to a Form
- Data which can be entered defined by the Form and Field Types

+++
@title[Form Record in UI]
![Form Record in UI](activityinfo/api/data-model/img/form-data-entry.png)

+++
@title[Form Record in Context]
![Form Record in Context](activityinfo/api/data-model/img/form-record-context.png)

+++
@title[Form Records Request]
## Query for Form Records

Generic Request for Form Records (in column-format):

```http
GET https://activityinfo.org/resources/form/{formId}/query/columns
```

+++
@title[Example 5 - Column Format]
## Example 5: Column-Format Query

For this example, we will send the following request:

```http
GET https://activityinfo.org/resources/form/a1234567890/query/columns
```

+++
@title[Column Format Response]
```json
{
    "rows": 3,
    "columns": {
        "Project Name": {
            "type": "STRING",
            "storage": "array",
            "values": [
                "Documentation",
                "New Field Development",
                "User Conference"
            ]
        },
        "Funding": {
            "type": "NUMBER",
            "storage": "array",
            "values": [
                0,
                5000,
                1000
            ]
        },
        "Project Code": {
            "type": "STRING",
            "storage": "array",
            "values": [
                "DOC001",
                "DEV001",
                "UC2018"
            ]
        },
        "partner.label": {
            "type": "STRING",
            "storage": "array",
            "values": [
                "Default",
                "BeDataDriven",
                "Default"
            ]
        },
        "@id": {
            "type": "STRING",
            "storage": "array",
            "values": [
                "s0044598181",
                "s0517446917",
                "s1625985119"
            ]
        },
        "date2": {
            "type": "STRING",
            "storage": "array",
            "values": [
                "2018-09-30",
                "2018-10-31",
                "2018-09-27"
            ]
        },
        "date1": {
            "type": "STRING",
            "storage": "array",
            "values": [
                "2018-07-01",
                "2018-10-01",
                "2018-09-26"
            ]
        },
        "partner.Full Name": {
            "type": "STRING",
            "storage": "empty"
        }
    }
}
```

@[2](`rows` gives the number of data rows returned)
@[3](`columns` gives the columns returned, with each column as a separate attribute)
@[4](Just like the `/rows` endpoint, the Query API will return fields by their code, or by their label otherwise)
@[5](Defines the JSON data type for the given column)
@[6](Defines the storage method: 'empty' for an empty column, 'constant' for a constant value for all rows, or 'array' for a separate value for each row)
@[7-11](The returned values for each row)

---

@title[Sub-Form Record]
# Sub-Form
# Record

@snap[east]
@fa[level-down fa-5x] @fa[file-text fa-5x]
@snapend

@snap[south]
@fa[arrow-down]
@snapend

+++
@title[Sub-Form Records]
## @color[#00CF79](Sub-Form Records)

- Same structure as a Form Record
- **EXCEPT** all Sub-Form Records reference a Parent Form Record via a `parent` field

+++
@title[Sub-Form Record in UI]
![Sub-Form Record in UI](activityinfo/api/data-model/img/subform-records.png)

+++
@title[Sub-Form Record in Context]
![Sub-Form Record in Context](activityinfo/api/data-model/img/subform-record-context.png)

+++
@title[Query for Sub-Form Records]
## Query for Sub-Form Records
Generic Request for Sub-Form Records (in row-format):

```http
GET https://activityinfo.org/resources/form/{subFormId}/query/rows
```

Generic Request for Sub-Form Records (in column-format):

```http
GET https://activityinfo.org/resources/form/{subFormId}/query/columns
```

+++
@title[Example 9: Sub-Form Records]
## Example 9: Sub-Form Records

For this example, we will send the following request:

```http
GET https://activityinfo.org/resources/form/cjmhib4oy1/query/rows
```

+++
@title[Sub-Form Records Response]
```json
[
    {
        "Parent.code": "UC2018",
        "descrip": "Room Rental",
        "cost": 1000,
        "Parent.proj": "User Conference 2018",
        "@id": "cjmj78nid8b",
        "Parent.partner.label": "BeDataDriven"
    },
    {
        "Parent.code": "UC2018",
        "descrip": "Stationary Supplies",
        "cost": 50,
        "Parent.proj": "User Conference 2018",
        "@id": "cjmk2jfu95n",
        "Parent.partner.label": "BeDataDriven"
    },
    {
        "Parent.code": "DEV001",
        "descrip": "Initial Proposal",
        "cost": 100,
        "Parent.proj": "New Field Development",
        "@id": "cjmk2kinrd7",
        "Parent.partner.label": "BeDataDriven"
    }
]
```

@[4-5](We have each of the fields on the Sub-Form)
@[6](As well as information from Parent From via `parent` reference)

---

@title[Form Record Update Request]
# Form Record
# Update Request

@snap[south]
@fa[arrow-down]
@snapend

+++
@title[Form Record Update Request Definition]
## @color[#00CF79](Form Record Update Request)

- Single endpoint for updating a Form 's Records
- Create, update and/or delete records via a single POST request

+++

@title[Form Record Update Request (HTTP Request)]
## Update Request
HTTP Method and URL for Updating a Form's Records:

```http
POST https://activityinfo.org/resources/update
```
+++

@title[Form Record Update Request (Request Body)]
## Update Request

Request Body for Updating a Form's Records:

```json
{
  "changes": [
    {
      "deleted": Boolean,
      "recordId": String,
      "formId": String,
      "fields": {
        "fieldId": String / Number,
        ...
      }
    },
    ...
  ]
}
```

@[2-13](Array of changes included in this update (1 or more))
@[3-11](A single change to a Form Record - Create/Update/Delete)
@[4](Are we deleting this record?)
@[5](Id of the Form Record we are Creating/Updating/Deleting)
@[6](Id of the Form)
@[7-10](Key-value of pairs of the Field Id and Field Values we are changing)

+++

Full list of Form Field Values, their JSON data type and expected format:
https://www.activityinfo.org/apidocs/index.html#field-types

---

@title[Creating a Form Record]
# Creating a
# Form Record

@snap[south]
@fa[arrow-down]
@snapend

+++

@title[Creating a Form Record (HTTP Request)]
## @color[#00CF79](Creating a Form Record)

We will send the following request to **create** a Form Record:

```http
POST https://activityinfo.org/resources/update
```

+++
@title[Creating a Form Record (Request Body)]

With the following Request Body:

```json
{
	"changes": [
		{
      "deleted": false,
			"recordId": "s1234567890",
			"formId": "a2145511746",
			"fields": {
				"a21455117460000000007": "P0000009909:p0000019616",
				"i1865815593": 1,
				"i0206378262": "One",
				"i0566126146": "2019-01-15"
			}
		}
	]
}
```

@[4](We are **not** deleting the Form Record)
@[5](Use a *random* string for our Form Record Id. A new id == a new Form Record)
@[6](Use your Form Id)
@[8]("a21455117460000000007" is our Partner Field, which is a reference to a Form Record in the Partner Form)
@[8](Reference Field Values are always in the form "{formId}:{recordId}")
@[9](Our Quantity Field needs a `number`)
@[10](Our Text Field needs a `string`)
@[11](Our Date Field needs a `string` in the form "YYYY-MM-DD")

---

@title[Updating a Form Record]
# Updating a
# Form Record

@snap[south]
@fa[arrow-down]
@snapend

+++

@title[Updating a Form Record (HTTP Request)]
## @color[#00CF79](Updating a Form Record)

We will send the following request to **update** a Form Record:

```http
POST https://activityinfo.org/resources/update
```

+++
@title[Updating a Form Record (Request Body)]

With the following Request Body:

```json
{
	"changes": [
		{
      "deleted": false,
      recordId": "s1234567890",
      formId": "a2145511746",
			"fields": {
				"i1865815593": 2,
				"i0206378262": "Two",
				"i0566126146": "2019-01-16"
			}
		}
	]
}
```

@[4](We are **not** deleting the Form Record)
@[5](Use the **same** id as before for our Form Record Id)
@[6](Use the same Form Id)
@[8](Change our Quantity Field Value to 2)
@[9](Change our Text Field Value to "Two")
@[10](Change our Date Field Value to "2019-01-16")

+++

- Note that we omitted our Partner Field from the update.
- Only need to include the Field Ids which we are modifying.

---

@title[Deleting a Form Record]
# Deleting a
# Form Record

@snap[south]
@fa[arrow-down]
@snapend

+++

@title[Deleting a Form Record (HTTP Request)]
## @color[#00CF79](Deleting a Form Record)

We will send the following request to **delete** a Form Record:

```http
POST https://activityinfo.org/resources/update
```

+++

@title[Deleting a Form Record (Request Body)]

With the following Request Body:

```json
{
	"changes": [
		{
      "deleted": true,
			"recordId": "s1234567890",
			"formId": "a2145511746"
		}
	]
}
```

@[4](We **are** deleting the Form Record)
@[5](Use the **same** id as before for our Form Record Id)
@[6](Use the same Form Id)

+++

- Note that we omitted our "fields" attribute from the request.
- No need to include the Field Values, as we are deleting the Form Record.

---

@title[Batching Updates to Form Records]
# Batching Updates to
# Form records

@snap[south]
@fa[arrow-down]
@snapend

+++

@title[Batching Updates to Form Records (HTTP Request)]
## @color[#00CF79](Batching Updates)

We will send the following request to **create, update and delete** multiple Form Records:

```http
POST https://activityinfo.org/resources/update
```

+++

@title[Batching Updates to Form Records (Request Body)]

With the following Request Body:

```json
{
	"changes": [
		{
			"deleted": false,
			"recordId": "s0000000001",
			"formId": "a2145511746",
			"fields": {
				"a21455117460000000007": "P0000009909:p0000019616",
				"i1865815593": 101,
				"i0206378262": "Batched Update 101",
				"i0566126146": "2019-01-15"
			}
		},
		{
			"deleted": false,
			"recordId": "s0000000002",
			"formId": "a2145511746",
			"fields": {
				"a21455117460000000007": "P0000009909:p0000019616",
				"i1865815593": 102,
				"i0206378262": "Batched Update 102",
				"i0566126146": "2019-02-15"
			}
		}
	]
}```

@[3-13](Create Form Record: Change 1)
@[14-24](Create Form Record: Change 2)

+++

- Can batch *any* set of operations together - Create, Update and/or Delete

---

@title[Pushing Data]
# Pushing Data

@snap[south]
@fa[arrow-down]
@snapend

+++

@title[Pushing Data: Basic Flow]
## @color[#00CF79](Pushing Data: Basic Flow)

1. **Extract** data from the source system
2. **Transform** data into required format
3. **Push** data to destination system (i.e. using API)

---

## ActivityInfo R Package

Make sure to install ActivityInfo-R Package in RStudio:
"install-ai-library.R"

---

## Example 1: Import Legacy Data (using R)

Files needed:
- "example-1-schools.R"
- "schools.csv"
- "schools.xls"

---

## Example 2: Integrating Different Databases (using R)

Files needed:
"example-2-indicators.R"
