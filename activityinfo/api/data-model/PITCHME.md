# ActivityInfo API
## @color[#00CF79](Data Model)

---

@title[Who is this talk for? - 1/2]
## Who is this talk for?
This is not a general talk on APIs. It will go into technical detail on the _ActivityInfo_ API. 

However, anyone with some technical background should be able to follow along.

---

@title[Who is this talk for? - 2/2]
## Who is this talk for?

This talk is intended for:
- Developers in organisations using ActivityInfo
- Members of organisations with developers capable of utilising REST APIs

---

@title[What is the aim of this talk?]
## What is the aim of this talk?

- Know how to use the ActivityInfo Data Model to extend your own applications
- Use data from ActivityInfo in your own applications

---
@title[Learning Outcomes]
## Learning Outcomes
From this presentation, you should understand:
- The basic objects of the ActivityInfo Data Model, and their structure
- The relationship between elements of the Data Model
- How to retrieve data from the ActivityInfo system
- The basic concepts needed to construct queries for the ActivityInfo Query API

---
@title[Topics]
## Topics
- Databases
- Forms
- Form Fields
- Form Records
- Reference Fields
- Sub-Forms
- Sub-Form Records
- Key Fields

---
@title[Set-Up]
## @color[#00CF79](Set-up)

Before we start, we need to set up our REST Client [Postman](https://www.getpostman.com/)

@snap[south]
@fa[arrow-down]
@snapend

+++
@title[Download Postman]
@snap[north-west]
<h4>Download the correct version for your system [here](https://www.getpostman.com/apps)</h4>
@snapend

@snap[midpoint]
![](activityinfo/api/data-model/img/postman-apps.png)
@snapend

+++
@title[Download API Collection]
@snap[north-west]
<h4>Download the ActivityInfo API Collection from [here](https://drive.google.com/open?id=1rSFoTVYSboDG58iSh4ge2FCKQQEHvH9j)</h4>
@snapend

@snap[midpoint]
@fa[download fa-4x]
@snapend

+++
@title[Install Postman]
@snap[north-west]
<h4>Install Postman - no need to create account</h4>
@snapend

@snap[midpoint]
![](activityinfo/api/data-model/img/postman-installed.png)
@snapend

+++
@title[Select Import]
@snap[north-west]
<h4>Select "Import" from the top-left corner</h4>
@snapend

@snap[midpoint]
![](activityinfo/api/data-model/img/postman-import-button.png)
@snapend

+++
@title[Select API Collection to Import]
@snap[north-west]
<h4>On the Import Screen, select "Browse Files" and find the ActivityInfo API collection</h4>
@snapend

@snap[midpoint]
![](activityinfo/api/data-model/img/postman-import-screen.png)
@snapend

+++ 
@title[Add Auth to Request Header]
@snap[north-west]
<h4>When making a Request, add your user details to the Request Header via Basic Authentication</h4>
@snapend

@snap[midpoint]
![](activityinfo/api/data-model/img/auth.png)
@snapend
---

# Database

@snap[east]
@fa[database fa-5x]
@snapend

@snap[south]
@fa[arrow-down]
@snapend

+++
@title[Database Definition]
## @color[#00CF79](Database)
- Central source of data
- All data are entered, maintained and reported on from one or more databases

+++
@title[Database in UI]
![Database in UI](activityinfo/api/data-model/img/database.png)

+++
@title[Database in Context]
![Database in Context](activityinfo/api/data-model/img/database-context.png)

+++
@title[Database Schema Request]
## Query for Database Schema
Generic Request for Database Schema:

```http
GET https://activityinfo.org/resources/database/{databaseId}
```

+++
@title[Example 1]
## Example 1

For this example, we will send the following request:

```http
GET https://activityinfo.org/resources/database/9909
```

+++
@title[Database Schema Response]
```json
{
    "databaseId": "d0000009909",
    "userId": 21598,
    "label": "ActivityInfo API Demo",
    "visible": true,
    "owner": true,
    "version": "1538007492056",
    "resources": [
        {
            "id": "a2145507922",
            "parentId": "d0000009909",
            "type": "FORM",
            "label": "Field Types"
        },
        {
            "id": "a2145507921",
            "parentId": "d0000009909",
            "type": "FORM",
            "label": "Ongoing Projects"
        },
        {
            "id": "f0000020524",
            "parentId": "d0000009909",
            "type": "FOLDER",
            "label": "Folder Example"
        },
        {
            "id": "a2145508135",
            "parentId": "d0000009909",
            "type": "FORM",
            "label": "Correspondence Form"
        },
        {
            "id": "a2145508134",
            "parentId": "d0000009909",
            "type": "FORM",
            "label": "Contact Form"
        },
        {
            "id": "a2145507925",
            "parentId": "f0000020524",
            "type": "FORM",
            "label": "Form-in-Folder Example"
        },
        {
            "id": "a2145507924",
            "parentId": "d0000009909",
            "type": "FORM",
            "label": "Sub-Forms"
        }
    ],
    "grants": [],
    "locks": []
}
```

@[2](Database Id)
@[3](Id of Requesting User)
@[4](Database Label/Name)
@[5](Is this Database visible to User?)
@[6](Is this User the owner?)
@[7](The current Database version)
@[8-14](Database `resources` show accessible Forms...)
@[21-26](...and Folders)
@[33-38](Resources can be contained within the database...)
@[39-44](...or contained within a folder)
@[52](Operations User is granted - N/A for owners)
@[53](Locks set on Database)

+++
@title[Database Schema Definition]
## Database Schema

```
Database: {
    "databaseId": string,
    "userId": int,
    "label": string,
    "visible": boolean,
    "owner": boolean,
    "version": string,
    "resources": [ Resource ],
    "grants": [ GrantModel ],
    "locks": [ LockModel ]
}
```

+++
@title[Resource Schema Definition]
## Resource Schema

```
Resource: {
	"id": string, 
	"parentId": string, 
	"type": string,
	"label": string
}
```

@[4](Enum choice of `{"FORM","FOLDER"}`)

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
![Form in UI - Design](activityinfo/api/data-model/img/form.png)

+++
@title[Form in UI - Data Entry]
![Form in UI - Data Entry](activityinfo/api/data-model/img/form-data-entry.png)

+++
@title[Form in Context - Root Level]
![Form in Context - Root Folder](activityinfo/api/data-model/img/form-context-1.png)

Forms can be held at the root level within a Database...

+++
@title[Form in Context - Folder]
![Form in Context - Folder](activityinfo/api/data-model/img/form-context-2.png)

...or within a user-created Folder.

+++
@title[Form Schema Request]
## Query for Form Schema
Generic Request for Form Schema:

```http
GET https://activityinfo.org/resources/form/{formId}/schema
```

+++
@title[Example 2]
## Example 2
For this example, we will send the following request:

```http
GET https://activityinfo.org/resources/form/a2145507921/schema
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

+++ 
@title[Common Field Attributes]
## Common Field Attributes

```
FormField: {
	"id": string,
	"code": string,
	"label": string,
	"description": string,
	"relevanceCondition": string,
	"visible": boolean,
	"required": boolean,
	"type": string,
	"key": boolean,
	"typeParameters": { FieldTypeParameter }
}
```

@[2](Id of Field - exact form depends on Field Type)
@[3](User defined 'short code' for the Field, if any)
@[4](Name of the Field as it appears in Data Entry)
@[5](Description of the Field for Users in Data Entry, if any)
@[6](Relevance Condition formula shows/hides Field depending on data entered in other Fields, if any)
@[7](Defines whether Field appears to User in Data Entry)
@[8](Defines whether Field must have data)
@[9](Defines the Field Type)
@[10](Defines whether it is a 'key' Field)
@[11](Set of parameters which depend on Field Type)

+++
@title[Field Types]
## Field Types
- Field Type is defined in Field Schema (`type`)
- Field Type may also have a specific set of parameters (`typeParameters`)

+++
@title[Field Type: Serial Number]
### Field Type: Serial Number

```json
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
}
```

@[2](Has form `i0000000000`)
@[9](Has type `serial`)
@[11](Defines the input mask, if any)
@[12](Defines the number of digits to generate)

+++
@title[Field Type: Quantity Field]
### Field Type: Quantity

```json
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
}
```

@[2](Has form `i0000000000`)
@[9](Has type `quantity`)
@[11](Defines the quantity units)
@[12](Defines the aggregation method)

+++
@title[Field Type: Text]
### Field Type: Text

```json
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
}
```

@[2](Has form `i0000000000`)
@[9](Has type `FREE_TEXT`)

+++
@title[Field Type: Multi-line Text]
### Field Type: Multi-Line Text

```json
{
	"id": "i2003200244",
	"code": null,
	"label": "Multi-line text",
	"description": null,
	"relevanceCondition": null,
	"visible": true,
	"required": false,
	"type": "NARRATIVE"
}
```

@[2](Has form `i0000000000`)
@[9](Has type `NARRATIVE`)

+++
@title[Field Type: Date]
### Field Type: Date

```json
{
	"id": "i0747756921",
	"code": null,
	"label": "Date",
	"description": null,
	"relevanceCondition": null,
	"visible": true,
	"required": false,
	"type": "date"
}
```

@[2](Has form `i0000000000`)
@[9](Has type `date`)

+++
@title[Field Type: Single/Multi Selection]
### Field Type: Single/Multiple Selection

```json
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
}
```

@[2](Has form `Q0000000000`)
@[9](Has type `enumerated`)
@[11](Defines the cardinality of the selection - either 'single' or 'multiple')
@[13-22](Defines the selection options a User can choose from)
@[15](Selection option always has id with form `t0000000000`)
@[16](Selection option label)

+++
@title[Field Type: Geographic Point]
### Field Type: Geographic Point

```json
{
	"id": "i0583669177",
	"code": null,
	"label": "Geographic point",
	"description": null,
	"relevanceCondition": null,
	"visible": true,
	"required": false,
	"type": "geopoint"
}
```

@[2](Has form `i0000000000`)
@[9](Has type `geopoint`)

+++
@title[Field Type: Barcode]
### Field Type: Barcode

```json
{
   "id": "i0405530436",
   "code": null,
   "label": "Barcode",
   "description": null,
   "relevanceCondition": null,
   "visible": true,
   "required": false,
   "type": "barcode"
}
```

@[2](Has form `i0000000000`)
@[9](Has type `barcode`)

+++
@title[Field Type: Image/Attachment]
### Field Type: Image/Attachment

```json
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
}
```

@[2](Has form `i0000000000`)
@[9](Has type `attachment`)
@[11](Defines the cardinality of the upload - either 'single' or 'multiple')
@[12](Defines the upload type - either 'image' or 'attachment')

+++
@title[Field Type: Calculated]
### Field Type: Calculated

```json
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
```

@[2](Has form `i0000000000`)
@[9](Has type `calculated`)
@[11](Defines the calculation formula)

+++
@[Side Note: Built-in Fields]
## Side-Note: Built-in Fields
- Generated for compatibility with Classic ActivityInfo Data Model
- `id` is a concatenation of Form Id and Built-in Field Type 

+++
@title[Built-In Fields: Partner Example]
## Example: Partner
```json
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
}
```
@[2-10](Still a normal Field Schema)
@[2](However `id` is "built-in" value of `a21455079220000000007`, where `a2145507922` is the `fieldId`)

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
Generic Request for Form Records (in row-format):

```http
GET https://activityinfo.org/resources/form/{formId}/query/rows
```

Generic Request for Form Records (in column-format):

```http
GET https://activityinfo.org/resources/form/{formId}/query/columns
```

+++
@title[Example 4 - Row Format]
## Example 4: Row-Format Query

For this example, we will send the following request:

```http
GET https://activityinfo.org/resources/form/a2145507921/query/rows
```

+++
@title[Row Format Response]
```json
[
    {
        "Project Name": "Documentation",
        "Funding": 0,
        "Project Code": "DOC001",
        "partner.label": "Default",
        "@id": "s0044598181",
        "date2": "2018-09-30",
        "date1": "2018-07-01"
    },
    {
        "Project Name": "New Field Development",
        "Funding": 5000,
        "Project Code": "DEV001",
        "partner.label": "BeDataDriven",
        "@id": "s0517446917",
        "date2": "2018-10-31",
        "date1": "2018-10-01"
    },
    {
        "Project Name": "User Conference",
        "Funding": 1000,
        "Project Code": "UC2018",
        "partner.label": "Default",
        "@id": "s1625985119",
        "date2": "2018-09-27",
        "date1": "2018-09-26"
    }
]
```

@[7](The `@id` Field gives Form Record Id)
@[8](The Query API will return fields by their code, if defined...)
@[12](...or by their full label otherwise.)

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


+++

What if we just want a _specific_ field? 

+++
@title[Query Parameters]
## Query Parameters
We can specify a query parameter in our request:

```http
.../query/columns?{desiredName}={formula}
```

- Can use any valid string for `desiredName` 
- A `formula` gives a path to a field, or a method to calculate the desired value
- `formula` is often a `fieldCode`, `fieldName`, or `fieldId`. 
- If the field has a space, surround it with `[...]` brackets.

+++
@title[Example 6]
## Example 6

For this example, we will send the following request:

```http
GET https://activityinfo.org/resources/form/a1234567890/query/columns?project=[Project Name]
```

+++
@title[Query Parameter Response]
```json
{
    "rows": 3,
    "columns": {
        "project": {
            "type": "STRING",
            "storage": "array",
            "values": [
                "Documentation",
                "New Field Development",
                "User Conference"
            ]
        }
    }
}
```

@[2](Still have 3 rows returned)
@[3-13](But we only have a single column returned - our Project Name field)
@[4](Column name is now our specified name from the query parameter)

---
@title[Reference Fields]
# Reference 
# Field

@snap[east]
@fa[link fa-5x]
@snapend

@snap[south]
@fa[arrow-down]
@snapend

+++
@title[Reference Field Definition]
## @color[#00CF79](Reference Fields)

- A particular Field Type which allows one Form to reference another Form
- Users can select a Form Record from another Form (e.g. a Location, Partner, etc.)
- Can then construct queries to obtain data from a referenced Form

+++
@title[Reference Field in UI - Correspondence Form]
![Reference Field in UI - Correspondence Form](activityinfo/api/data-model/img/ref-field-data-entry-1.png)

+++
@title[Reference Field in UI - Contact Form]
![Reference Field in UI - Contact Form](activityinfo/api/data-model/img/ref-field-data-entry-2.png)

+++
@title[Reference Field in Context]
![Reference Field in Context](activityinfo/api/data-model/img/ref-field.png)

+++
@title[Example 7.1: Form Schema with Reference Field]
## Example 7.1: Form Schema with Reference Field 

Let's get the schema of a form with a Reference Field:

```http
GET https://activityinfo.org/resources/form/a2145507921/schema
```

+++
@title[Reference Field Schema Response]

```json
{
    "id": "a2145508135",
    "schemaVersion": 1,
    "databaseId": "d0000009909",
    "label": "Correspondence Form",
    "elements": [
        {
            "id": "a21455081350000000007",
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
            "id": "i1962994487",
            "code": null,
            "label": "Contact",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "reference",
            "typeParameters": {
                "cardinality": "single",
                "range": [
                    {
                        "formId": "a2145508134"
                    }
                ]
            }
        },
        {
            "id": "Q1293339027",
            "code": null,
            "label": "Discussion",
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
                        "id": "t1292954278",
                        "label": "Support"
                    },
                    {
                        "id": "t1293531401",
                        "label": "Training"
                    },
                    {
                        "id": "t0862657783",
                        "label": "Follow-up"
                    }
                ]
            }
        },
        {
            "id": "a21455081350000000014",
            "code": "comments",
            "label": "Comments",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "NARRATIVE"
        }
    ]
}
```
@[25-42](Our Corresponsdence Form contains a Reference Field "Contact")
@[33](Has type `reference`)
@[35](Defines the cardinality of the selection - either 'single' or 'multiple')
@[36-39](Defines the Forms from which a User can select a Form Record)
@[38](We see that the Contact Reference Field references the Form 'a2145508134')

+++
@title[Example 7.2: Reference Field Value]
## Example 7.2: Reference Field Value

Let's find the selected records from our Partner Reference Field:

```http
GET https://activityinfo.org/resources/form/a2145507921/query/rows?referenceField=partner
```

+++
@title[Reference Field Value Response]
```
[
    {
        "contactRefValue": "s1846376438"
    },
    {
        "contactRefValue": "s1695023718"
    }
]
```
@[3](This Record in the Correspondance Form references record `s1846376438` on our Contact Form)
@[6](This Record in the Correspondance Form references record `s1695023718` on our Contact Form)

+++
@title[Using References in Query API]
## Using References in Query API

- We have seen a from Correspondance Form -> Contact Form
- Now we can get further data from the Contact Form by creating a query formula

+++
@title[Creating References for Query API]
## Using References in Query API

A Field from another Form can be referenced by:
- Finding the code/label of the Reference Field in your Form (e.g. 'Contact')
- Finding the Field you wish to extract data from on the referenced Form (e.g. 'First Name' for the Contact's Name Field)
- Creating a query formula via dot '.' notation to make a path to the field (i.e. "Contact.[First Name]")

+++
@title[Example 7.3]
## Example 7.3: References in Query API
Let's get the Contact's First and Last Name for each record on our Correspondance Form:

```http
GET .../query/rows?discussion=Discussion&contactFirstName=Contact.[First Name]&contactLastName=Contact.[Last Name]
```

+++
@title[Example 7.3 Response]
```json
[
    {
        "contactFirstName": "Lucy",
        "contactLastName": "Brinks",
        "discussion": "Support"
    },
    {
        "contactFirstName": "Jamie",
        "contactLastName": "Whitehouse",
        "discussion": "Training"
    }
]
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

+++
@title[Information from Parent Forms]
## Example 10: Query for Parent Form Information

Just as we used Reference Fields to query for information from another Form, we can query for information from a Parent Form Record:

```http
.../query/rows?subFormRecord=descrip&parentFormRecord=parent.proj
```

+++
@title[Parent Form Information Response]
```json
[
    {
        "parentFormRecord": "User Conference 2018",
        "subFormRecord": "Room Rental"
    },
    {
        "parentFormRecord": "User Conference 2018",
        "subFormRecord": "Stationary Supplies"
    },
    {
        "parentFormRecord": "New Field Development",
        "subFormRecord": "Initial Proposal"
    }
]
```

---

# Key Field

@snap[east]
@fa[key fa-5x]
@snapend

@snap[south]
@fa[arrow-down]
@snapend

+++
@title[Key Field Definition]
## @color[#00CF79](Key Fields)

- Fields which identify a **unique** record in a Form in a user-friendly way
- Can be a set of keys (e.g. Last Name, First Name)

+++
@title[Key Field in UI]
![Reference Field in UI - Correspondence Form](activityinfo/api/data-model/img/key-field.png)

+++
@title[Example 11: Key Fields on Form Schema]
## Example 11: Key Fields on Form Schema

Let's get the schema of a form with a Key Field:

```http
GET https://activityinfo.org/resources/form/a2145508134/schema
```

+++
@title[Key Field Schema Response]

```json
{
    "id": "a2145508134",
    "schemaVersion": 1,
    "databaseId": "d0000009909",
    "label": "Contact Form",
    "elements": [
        {
            "id": "a21455081340000000007",
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
            "id": "i0213240773",
            "code": null,
            "label": "Last Name",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "FREE_TEXT",
            "key": true,
            "typeParameters": {}
        },
        {
            "id": "i1744487760",
            "code": null,
            "label": "First Name",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "FREE_TEXT",
            "key": true,
            "typeParameters": {}
        },
        {
            "id": "i1592527269",
            "code": null,
            "label": "Country Code",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "quantity",
            "typeParameters": {
                "units": "",
                "aggregation": "SUM"
            }
        },
        {
            "id": "i1624653802",
            "code": null,
            "label": "Phone Number",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "quantity",
            "typeParameters": {
                "units": "",
                "aggregation": "SUM"
            }
        }
    ]
}
```
@[25-36](We have a Text Key Field 'Last Name')
@[37-48](And a Text Key Field 'First Name')
@[46](Key Fields are spcified by the `key` attribute on the Form Field Schema)



