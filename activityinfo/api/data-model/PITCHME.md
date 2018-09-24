# ActivityInfo API
## @color[#00CF79](Data Model)

---

## Learning Outcomes
From this presentation, you should understand:
- The basic objects of the ActivityInfo Data Model, and their structure
- The relationship between elements of the Data Model
- How to retrieve data from the ActivityInfo system 
- The basic concepts needed to construct queries for the ActivityInfo Query API

---

## Topics
- Databases
- Forms
- Form Fields
- Form Records
- Reference Fields
- Sub Forms
- Sub Form Records
- Key Fields

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
GET https://activityinfo.org/resources/database/9909
```

+++

```json
{
    "databaseId": "d0000009909",
    "userId": 21598,
    "label": "ActivityInfo API Demo",
    "visible": true,
    "owner": true,
    "version": "1537789333111",
    "resources": [
        {
            "id": "a2145507923",
            "parentId": "d0000009909",
            "type": "FORM",
            "label": "Reference Form"
        },
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
            "label": "Basic Form"
        },
        {
            "id": "f0000020524",
            "parentId": "d0000009909",
            "type": "FOLDER",
            "label": "Folder Example"
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
@[8-14](Database Resources show accessible Forms and Folders)
@[33-38](Resources can be caontained within the database, or within a folder)
@[46](Operations User is granted - N/A for owners)
@[47](Locks set on Database)

+++

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

@[2](Has form `L0000000000`)
@[7](Has form `0+` for database owners, or `0+#0+` for database users)

+++

## Resource Schema

```
Resource: {
	"id": string, 
	"parentId": string, 
	"type": string,
	"label": string
}
```

@[2](Has form `L0000000000`)
@[3](Has form `L0000000000`)
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
GET https://activityinfo.org/resources/form/a2145507921/schema
```

+++

```json
{
    "id": "a2145507921",
    "schemaVersion": 1,
    "databaseId": "d0000009909",
    "label": "Basic Form",
    "elements": [
        {
            "id": "a21455079210000000012",
            "code": "date1",
            "label": "Start Date",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": true,
            "type": "date"
        },
        ...
    ]
}
```

@[2](Form Id)
@[3](Form Schema Version)
@[4](Database Id)
@[5](Form Label/Name)
@[6-16](Form Elements i.e. Fields)

+++

## Form Schema

```
Form: {
	"id": string,
	"schemaVersion": int,
	"databaseId": string,
	"label": string,
	"elements": [ FormField ]
}
```

@[2](Has form `L0000000000`)
@[4](Has form `L0000000000`)

---

# Form Field 

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

Form Field is defined within a Form Schema. Therefore we use a generic request for Form Schema:

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
    "id": "a2145507922",
    "schemaVersion": 1,
    "databaseId": "d0000009909",
    "label": "Field Types",
    "elements": [
        {
            "id": "a21455079220000000012",
            "code": "date1",
            "label": "Start Date",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": true,
            "type": "date"
        },
        {
            "id": "a21455079220000000013",
            "code": "date2",
            "label": "End Date",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": true,
            "type": "date"
        },
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
            "id": "a21455079220000000008",
            "code": "project",
            "label": "Project",
            "description": null,
            "relevanceCondition": null,
            "visible": false,
            "required": false,
            "type": "reference",
            "typeParameters": {
                "cardinality": "single",
                "range": [
                    {
                        "formId": "R0000009909"
                    }
                ]
            }
        },
        {
            "id": "a21455079220000000014",
            "code": "comments",
            "label": "Comments",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "NARRATIVE"
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
@[6-15](We will focus on the "elements" property of the Form schema)

+++ 

## Built-in Fields
```json
"elements": [
	{
		"id": "a21455079220000000012",
		"code": "date1",
		"label": "Start Date",
		"description": null,
		"relevanceCondition": null,
		"visible": true,
		"required": true,
		"type": "date"
	},
	{
		"id": "a21455079220000000013",
		"code": "date2",
		"label": "End Date",
		"description": null,
		"relevanceCondition": null,
		"visible": true,
		"required": true,
		"type": "date"
	},
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
		"id": "a21455079220000000008",
		"code": "project",
		"label": "Project",
		"description": null,
		"relevanceCondition": null,
		"visible": false,
		"required": false,
		"type": "reference",
		"typeParameters": {
		    "cardinality": "single",
		    "range": [
		        {
		            "formId": "R0000009909"
		        }
		    ]
		}
	},
	{
		"id": "a21455079220000000014",
		"code": "comments",
		"label": "Comments",
		"description": null,
		"relevanceCondition": null,
		"visible": true,
		"required": false,
		"type": "NARRATIVE"
	}
]
```

@[2-11](Built-in Start Date Field)
@[12-21](Built-in End Date Field)
@[22-39](Built-in Partner Field **Required**)
@[40-57](Built-in Project Field)
@[58-67](Built-in Comments Field)

+++

## Field Types
```json
"elements": [
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
```

@[2-15](Serial Number Field)
@[16-29](Quantity Field)
@[30-40](Text Field)
@[41-50](Multi-Line Text Field)
@[51-60](Date Field)
@[61-84](Multiple Selection Field)
@[85-108](Single Selection Field)
@[109-118](Geographic Point Field)
@[119-128](Barcode Field)
@[129-142](Image Field)
@[143-156](Attachments Field)
@[157-169](Calculated Field)

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
- Data which can be entered defined by the Form and Field Types

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


