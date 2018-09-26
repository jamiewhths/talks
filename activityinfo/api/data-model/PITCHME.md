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
@[6-15](We will focus on the "elements" property of the Form schema...)

+++ 

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
@[10](Set of parameters which depend on Field Type)

+++

## Built-In Fields

Automatically created Fields when a new Form is created.

+++

### Built-in Fields: Start Date

```json
{
	"id": "a21455079220000000012",
	"code": "date1",
	"label": "Start Date",
	"description": null,
	"relevanceCondition": null,
	"visible": true,
	"required": true,
	"type": "date"
}
```

@[2](Always has id `{formId}0000000012`)

+++

### Built-in Fields: End Date

```json
{
	"id": "a21455079220000000013",
	"code": "date2",
	"label": "End Date",
	"description": null,
	"relevanceCondition": null,
	"visible": true,
	"required": true,
	"type": "date"
}
```
@[2](Always has id `{formId}0000000013`)

+++

### Built-in Fields: Partner (Required)

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
@[2](Always has id `{formId}0000000007`)

+++

### Built-in Fields: Project

```json
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
}
```
@[2](Always has id `{formId}0000000008`)

+++

### Built-in Fields: Comments

```json
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
```
@[2](Always has id `{formId}0000000014`)

+++

## Field Types

+++

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

+++

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
@[12](Defines the aggregation method - always set to SUM)

+++

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
@[12](Defines the upload type - either 'image' or 'attachment')

+++

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
GET https://activityinfo.org/resources/form/a2145507921/query/rows
```

+++

```json
[
    {
        "comments": "Third Record",
        "User-Added Field": 3,
        "partner.label": "Default",
        "@id": "s0044598181",
        "date2": "2018-10-31",
        "date1": "2018-10-01"
    },
    {
        "comments": "Second Record",
        "User-Added Field": 2,
        "partner.label": "Default",
        "@id": "s0517446917",
        "date2": "2018-09-30",
        "date1": "2018-09-01"
    },
    {
        "comments": "First Record",
        "User-Added Field": 1,
        "partner.label": "Default",
        "@id": "s1625985119",
        "date2": "2018-09-25",
        "date1": "2018-09-24"
    }
]
```

@[6](The '@id' Field gives Form Record Id)
@[8](The Query API will return fields by their code, if defined...)
@[12](...or by their full label otherwise.)

+++

## Column-Format Example

+++

For this example, we will send the following request:

```
GET https://activityinfo.org/resources/form/a1234567890/query/columns
```

+++

```json
{
    "rows": 3,
    "columns": {
        "comments": {
            "type": "STRING",
            "storage": "array",
            "values": [
                "Third Record",
                "Second Record",
                "First Record"
            ]
        },
        "User-Added Field": {
            "type": "NUMBER",
            "storage": "array",
            "values": [
                3,
                2,
                1
            ]
        },
        "project.label": {
            "type": "STRING",
            "storage": "empty"
        },
        "project.Description": {
            "type": "STRING",
            "storage": "empty"
        },
        "partner.label": {
            "type": "STRING",
            "storage": "constant",
            "value": "Default"
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
                "2018-10-31",
                "2018-09-30",
                "2018-09-25"
            ]
        },
        "date1": {
            "type": "STRING",
            "storage": "array",
            "values": [
                "2018-10-01",
                "2018-09-01",
                "2018-09-24"
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

# References

@snap[east]
@fa[link fa-5x]
@snapend

@snap[south]
@fa[arrow-down]
@snapend

+++

## @color[#00CF79](Reference Fields)

- A particular Field Type which allows one Form to reference another Form
- Users can select a Form Record from another Form (e.g. a Location, Partner, etc.)
- Can then construct queries to obtain data from a referenced Form

+++

## Reference Field Schema

Let's get the schema of an already created Reference Field - the built-in Partner Field:

```
GET https://activityinfo.org/resources/form/a2145507921/schema
```

+++

```
{
   "id": "a21455079210000000007",
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
@[9](Has type `reference`)
@[11](Defines the cardinality of the selection - either 'single' or 'multiple')
@[12-16](Defines the range of Forms from which a User can select a Form Record)
@[14](We see that the Partner Field references the Partner Form 'P0000009909')

+++

## Reference Field Value

Let's find the selected records from our Partner Reference Field:

```
GET https://activityinfo.org/resources/form/a2145507921/query/columns?referenceField=partner
```

+++

```
{
    "rows": 3,
    "columns": {
        "referenceField": {
            "type": "STRING",
            "storage": "array",
            "values": [
                "p0000019616",
                "p0000019619",
                "p0000019616"
            ]
        }
    }
}
```
@[7-11](The returned values for each row give the selected Form Records on the Partner Form 'P0000009909')

+++

## Using References in Query API

Now that we have established a link from our form to the Partner Form, we can get further data from the Partner Form by creating a query formula.

+++

## Using References in Query API

A Field from another Form can be referenced by:
- Finding the code/label of the Reference Field in your Form (e.g. 'partner')
- Finding the Field you wish to extract data from on the referenced Form (e.g. 'label' for the Partner's Name Field)
- Creating a query formula via dot '.' notation (i.e. "partner.label")

+++

Let's get the Partner's Name for each record on our Form:

```
GET https://activityinfo.org/resources/form/a2145507921/query/rows?record=comments&partnerName=partner.label
```

+++

```json
[
    {
        "partnerName": "Default",
        "record": "Third Record"
    },
    {
        "partnerName": "BeDataDriven",
        "record": "Second Record"
    },
    {
        "partnerName": "Default",
        "record": "First Record"
    }
]
```

---

# Sub-Forms

@snap[east]
@fa[file fa-5x]
@snapend

@snap[south]
@fa[arrow-down]
@snapend

+++

## @color[#00CF79](Sub-Form)

- Contained within a Parent Form
- Allows Users to submit multiple entries on a single Form Record (e.g. Monthly)
- Reference Fields establish a connection between the Parent Form and Sub-Form

+++

! Sub-Form in UI !

+++

![Sub-Form in Context](activityinfo/api/data-model/subform-context.png)

+++

We can use the same endpoint for retrieving a Sub-Form Schema:

```
GET https://activityinfo.org/resources/form/{subFormId}/schema
```

+++

To find our Sub-Form Id, we retrieve the Parent Form's schema first:

```
GET https://activityinfo.org/resources/form/a2145507924/schema
```

+++

## Parent Form

```json
{
    "id": "a2145507924",
    "schemaVersion": 1,
    "databaseId": "d0000009909",
    "label": "Sub-Forms",
    "elements": [
        {
            "id": "a21455079240000000012",
            "code": "date1",
            "label": "Start Date",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": true,
            "type": "date"
        },
        {
            "id": "a21455079240000000013",
            "code": "date2",
            "label": "End Date",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": true,
            "type": "date"
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
            "id": "a21455079240000000008",
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
            "id": "a21455079240000000014",
            "code": "comments",
            "label": "Comments",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "NARRATIVE"
        },
        {
            "id": "i2093438408",
            "code": null,
            "label": "Repeating Sub-Form",
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

@[73-85](Our Sub-Form Reference Field)
@[81](Has type `subform`)
@[83](Our Sub-Form Id is `cjmhib4oy1`)

+++


We can use the same endpoint for retrieving a Sub-Form Schema:

```
GET https://activityinfo.org/resources/form/{subFormId}/schema
```

+++

Using our Sub-Form Id, we will send the following request to find our Sub-Form Schema:

```
GET https://activityinfo.org/resources/form/cjmhib4oy1/schema
```

+++

## Sub-Form

```json
{
    "id": "cjmhib4oy1",
    "schemaVersion": 0,
    "databaseId": "d0000009909",
    "label": "Repeating Sub-Form",
    "parentFormId": "a2145507924",
    "subFormKind": "repeating",
    "elements": [
        {
            "id": "i0701024476",
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
            "id": "i0337573943",
            "code": "rec",
            "label": "Sub-Form Record",
            "description": null,
            "relevanceCondition": null,
            "visible": true,
            "required": false,
            "type": "NARRATIVE"
        }
    ]
}
```

@[2-5](Sub-Forms share the same basic attributes as Forms)
@[6](Includes an extra `parentFormId` attribute...)
@[7](And an extra 'subFormKind`, which specifies the reporting interval of the Sub-Form entries)
@[8](Form Fields appear as `elements` in the same way as Forms)

+++

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

@[2](Has form `L0000000000`)
@[4](Has form `L0000000000`)
@[7](Enum choice of `{ 'repeating', 'daily', 'weekly', 'biweekly' 'monthly' })

---

# Sub-Form 
# Records

@snap[east]
@fa[level-down fa-5x] @fa[file-text fa-5x]
@snapend

@snap[south]
@fa[arrow-down]
@snapend

+++

## @color[#00CF79](Sub-Form Records)

- Same structure as a Form Record, with one key difference: all Sub-Form Records are explicitly associated with a Parent Form Record
- Each Sub-Form Record references a Parent Form Record in a `parent` field

+++

! Sub-Form Records in UI goes here !

+++

![Sub-Form Record in Context](activityinfo/api/data-model/img/form-record-context.png)

+++

Generic Request for Form Records (in row-format):

```
GET https://activityinfo.org/resources/form/{subFormId}/query/rows
```

Generic Request for Form Records (in column-format):

```
GET https://activityinfo.org/resources/form/{subFormId}/query/columns
```

+++

## Row-Format Example

+++

For this example, we will send the following request:

```
GET https://activityinfo.org/resources/form/cjmhib4oy1/query/rows
```

+++

```json
[
    {
        "Parent.date2": "2018-09-26",
        "Parent.comments": "Parent Form Record 1",
        "rec": "Sub-Form Record 1",
        "Quantity": 1,
        "@id": "cjmj77kkx1",
        "Parent.date1": "2018-09-26",
        "Parent.partner.label": "Default"
    },
    {
        "Parent.date2": "2018-09-26",
        "Parent.comments": "Parent Form Record 1",
        "rec": "Sub-Form Record 2",
        "Quantity": 2,
        "@id": "cjmj7882f4g",
        "Parent.date1": "2018-09-26",
        "Parent.partner.label": "Default"
    },
    {
        "Parent.date2": "2018-10-31",
        "Parent.comments": "Parent Form Record 2",
        "rec": "Sub-Form Record 1",
        "Quantity": 1,
        "@id": "cjmj78nid8b",
        "Parent.date1": "2018-10-01",
        "Parent.partner.label": "BeDataDriven"
    }
]
```

+++

## Information from Parent Form

Just as we used Reference Fields to query for information from another Form, we can query for information from a Parent Form Record:

```
GET https://activityinfo.org/resources/form/cjmhib4oy1/query/rows?subFormRecord=rec&parentFormRecord=parent.comments
```

+++

```json
[
    {
        "parentFormRecord": "Parent Form Record 1",
        "subFormRecord": "Sub-Form Record 1"
    },
    {
        "parentFormRecord": "Parent Form Record 1",
        "subFormRecord": "Sub-Form Record 2"
    },
    {
        "parentFormRecord": "Parent Form Record 2",
        "subFormRecord": "Sub-Form Record 1"
    }
]
```

---

# Key Fields


