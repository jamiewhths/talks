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

You can still use our new **Importer**!

[Try the Beta here](https://v4alpha-dot-activityinfoeu.appspot.com)

(Login with your normal details)

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
- Create, Update and Delete a Form Record via API
- Batched Updates to Form Records via API
- Basic Concepts for Pushing Data
- Example 1: Import Legacy Data (using R)
- Example 2: Integrating Different Databases (using R)

---

@title[Data Model Review]
## @color[#00CF79](Data Model Review)

To prepare, let's review:
- Forms and Sub-Forms
- Form Fields
- Form and Sub-Form Records
- Reference Fields

+++

@title[Form Definition]
## @color[#00CF79](Form)

- Organises the various data to be collected, and how they link together
- Composed of one or more Fields which represent a type of data to be collected

+++

@title[Form in Context]
![Form in Context](activityinfo/api/data-model/img/form-context-1.png)

+++

@title[Sub-Form Definition]
## @color[#00CF79](Sub-Form)

- Contained within a Parent Form
- Submit multiple entries within a single Form Record (e.g. Monthly)
- Reference Fields connect the Parent Form and Sub-Form

+++

@title[Sub-Form in Context]
![Sub-Form in Context](activityinfo/api/data-model/img/subform-context.png)

+++

@title[Form Field Definition]
## @color[#00CF79](Field)

- Represents a specific type of data to be collected
- Different set of properties depending on the Field Type

+++

@title[Form Field in Context]
![Form Field in Context](activityinfo/api/data-model/img/field-context.png)

+++

@title[Field Types]
## Field Types
- Field Type is defined in Field Schema (`type`)
- Field Type may also have a specific set of parameters (`typeParameters`)

+++

@title[Form Records Definition]
## @color[#00CF79](Form Records)

- Created when a User submits an entry to a Form
- Data which can be entered defined by the Form and Field Types

+++

@title[Form Record in Context]
![Form Record in Context](activityinfo/api/data-model/img/form-record-context.png)

+++

@title[Sub-Form Records]
## @color[#00CF79](Sub-Form Records)

- Same structure as a Form Record
- **EXCEPT** all Sub-Form Records reference a Parent Form Record via a `parent` field

+++

@title[Sub-Form Record in Context]
![Sub-Form Record in Context](activityinfo/api/data-model/img/subform-record-context.png)

+++

@title[Reference Field Definition]
## @color[#00CF79](Reference Fields)

- A particular Field Type which allows one Form to reference another Form
- Users can select a Form Record from another Form (e.g. a Location, Partner, etc.)
- Can then construct queries to obtain data from a referenced Form

+++

@title[Reference Field in Context]
![Reference Field in Context](activityinfo/api/data-model/img/ref-field.png)

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
      "deleted": boolean,
      "recordId": String,
      "formId": String,
      "fields": {
        "fieldId": {String; Number},
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
# Batching
# Updates

@snap[south]
@fa[arrow-down]
@snapend

+++

@title[Batching Updates (HTTP Request)]
## @color[#00CF79](Batching Updates)

We will send the following request to **create, update and delete** multiple Form Records:

```http
POST https://activityinfo.org/resources/update
```

+++

@title[Batching Updates (Request Body)]

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
