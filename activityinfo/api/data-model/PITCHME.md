# ActivityInfo API
## @color[#00CF79](Data Model)

---

## @color[#00CF79](Set-up)

Before we start, we need to set up our REST Client [Postman](https://www.getpostman.com/)

@snap[south]
@fa[arrow-down]
@snapend

+++

@snap[north-west]
<h4>Download the correct version for your system [here]("https://www.getpostman.com/apps")</h4>
@snapend

@snap[midpoint]
![](activityinfo/api/data-model/img/postman-apps.png)
@snapend

+++

@snap[north-west]
<h4>Download the ActivityInfo API Collection from [here](https://github.com/jamiewhths/talks/activityinfo/api/data-model/resources/collections.api)</h4>
@snapend

@snap[midpoint]
@fa[download fa-4x]
@snapend

+++

@snap[north-west]
<h4>Install Postman - no need to create account</h4>
@snapend

@snap[midpoint]
![](activityinfo/api/data-model/img/postman-installed.png)
@snapend

+++

@snap[north-west]
<h4>Select "Import" from the top-left corner</h4>
@snapend

@snap[midpoint]
![](activityinfo/api/data-model/img/postman-import-button.png)
@snapend

+++

@snap[north-west]
<h4>On the Import Screen, select "Browse Files" and find the ActivityInfo API collection</h4>
@snapend

@snap[midpoint]
![](activityinfo/api/data-model/img/postman-import-screen.png)
@snapend

+++ 

# Authorization

---

# Database

@snap[east]
@fa[database fa-5x]
@snapend

@snap[south]
@fa[arrow-down]
@snapend

+++

## @color[#00CF79](Database)
- Central source of data
- All data are entered, maintained and reported on from one or more databases

+++

! Database in UI goes here !

+++

![Database in Context](activityinfo/api/data-model/img/database-context.png)

+++

Generic Request for Database Schema:

```
GET https://activityinfo.org/resources/database/{databaseId}
```

+++

For this example, we will send the following request:

```
GET https://activityinfo.org/resources/database/d1234567890
```

+++

```json
{
    "databaseId": "d0000009699",
    "userId": 21598,
    "label": "Books Distribution",
    "visible": true,
    "owner": true,
    "version": "1536759623158",
    "resources": [
        {
            "id": "f0000020207",
            "parentId": "d0000009699",
            "type": "FOLDER",
            "label": "Central Macedonia - GR"
        },
        {
            "id": "a2145506925",
            "parentId": "d0000009699",
            "type": "FORM",
            "label": "Greek Schools Book Provision"
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
@[8-21](Database Resources show accessible Forms and Folders)
@[22](Operations User is granted - N/A for owners)
@[23](Locks set on Database)

---

# Form

@snap[east]
@fa[file fa-5x]
@snapend

@snap[south]
@fa[arrow-down]
@snapend

+++

## @color[#00CF79](Form)

- Defines the various data to be collected, and how they link together
- Composed of one or more Fields which represent a type of data to be collected

+++

! Form in UI (design) goes here !

+++

! Form in UI (data entry) goes here !

+++

![Form in Context - Root Folder](activityinfo/api/data-model/img/form-context-1.png)

Forms can be held at the root level within a Database...

+++

![Form in Context - Folder](activityinfo/api/data-model/img/form-context-2.png)

...or within a user-created Folder.

+++

Generic Request for Form Schema:

```
GET https://activityinfo.org/resources/form/{formId}/schema
```

+++

For this example, we will send the following request:

```
GET https://activityinfo.org/resources/form/a1234567890/schema
```

+++

```json
{
    "id": "a2145506925",
    "schemaVersion": 1,
    "databaseId": "d0000009699",
    "label": "Greek Schools Book Provision",
    "elements": [
		  {
            "id": "a21455069250000000014",
            "label": "Comments",
            "visible": true,
            "required": false,
            "type": "NARRATIVE"
        },
        ...
    ]
}
```

@[2](Form Id)
@[3](Form Schema Version)
@[4](Database Id)
@[5](Form Label/Name)
@[6-15](Form Elements i.e. Fields)

---

# Field 

@snap[east]
@fa[th-list fa-5x]
@snapend

@snap[south]
@fa[arrow-down]
@snapend

+++

## @color[#00CF79](Field)

- Represents a specific type of data to be collected
- Different sets of properties depending on the Field Type

+++

! Field in UI goes here !

+++

![Field in Context](activityinfo/api/data-model/img/field-context.png)

+++

Field is defined within a Form Scham. Therefore we use a generic request for Form Schema:

```
GET https://activityinfo.org/resources/form/{formId}/schema
```

+++

For this example, we will send the following request:

```
GET https://activityinfo.org/resources/form/a1234567890/schema
```

+++

Let us focus on the "elements" property of the schema:

+++

```json
{
    "id": "a2145506925",
    "schemaVersion": 1,
    "databaseId": "d0000009699",
    "label": "Greek Schools Book Provision",
    "elements": [
		  {
            "id": "a21455069250000000014",
            "label": "Comments",
            "visible": true,
            "required": false,
            "type": "NARRATIVE"
        },
        ...
    ]
}
```

@[6-15](Form Elements)

---

# Form Records

@snap[east]
@fa[file-text fa-5x]
@snapend

@snap[south]
@fa[arrow-down]
@snapend

+++

## @color[#00CF79](Form Records)

- Created when a User submits an entry to a Form
- Data which can be entered by User defined by the Form and Field Types

+++

! Form Record in UI goes here !

+++

![Form Record in Context](activityinfo/api/data-model/img/form-record-context.png)

+++

Generic Request for Form Records (in row-format):

```
GET https://activityinfo.org/resources/form/{formId}/query/rows
```

Generic Request for Form Records (in column-format):

```
GET https://activityinfo.org/resources/form/{formId}/query/columns
```

+++

## Row-Format Example

+++

For this example, we will send the following request:

```
GET https://activityinfo.org/resources/form/a1234567890/query/rows
```

+++

```json
{
    "id": "a2145506925",
    "schemaVersion": 1,
    "databaseId": "d0000009699",
    "label": "Greek Schools Book Provision",
    "elements": [
		  {
            "id": "a21455069250000000014",
            "label": "Comments",
            "visible": true,
            "required": false,
            "type": "NARRATIVE"
        },
        ...
    ]
}
```

@[6-15](Form Elements)

+++

## Column-Format Example

+++

For this example, we will send the following request:

```
GET https://activityinfo.org/resources/form/a1234567890/query/column
```

+++

```json
{
    "id": "a2145506925",
    "schemaVersion": 1,
    "databaseId": "d0000009699",
    "label": "Greek Schools Book Provision",
    "elements": [
		  {
            "id": "a21455069250000000014",
            "label": "Comments",
            "visible": true,
            "required": false,
            "type": "NARRATIVE"
        },
        ...
    ]
}
```

@[6-15](Form Elements)

---

# Reference Fields

---

# Sub-Forms

---

# Sub-Form Records

---

# Key Fields


