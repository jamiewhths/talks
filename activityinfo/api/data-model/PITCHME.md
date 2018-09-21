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

---

# Database

@snap[east]
@fa[database fa-5x]
@snapend

---

## @color[#00CF79](Database)
- Central source of data
- All data are entered, maintained and reported on from one or more databases

---

![Database in UI](activityinfo/api/data-model/img/database.png)

---

![Database in Context](activityinfo/api/data-model/img/database-context.png)

---

```
GET https://activityinfo.org/resources/database/{databaseId}
```

---

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
@fa[file-text fa-5x]
@snapend

---

## @color[#00CF79](Form)

- Defines the various data to be collected, and how they link together
- Composed of one or more Fields which represent a type of data to be collected

---

![Form in UI - Design](activityinfo/api/data-model/img/form-design.png)

---

![Form in UI - Data Entry](activityinfo/api/data-model/img/form-data-entry.png)

---

![Form in Context](activityinfo/api/data-model/img/form-context.png)

---

```
GET https://activityinfo.org/resources/form/{formId}
```

---

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

