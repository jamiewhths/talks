library("activityinfo")

# EXTRACT
## Schools are kept in two files of different formats and with different schema
schoolsCsv <- read.csv("schools.csv")
schoolsXls <- readxl::read_xls("primary-schools.xls")

# TRANSFORM
## Need to transform our data into a list of school name, address and population
schools <- list(
  name = list(),
  address = list(),
  population = list()
)

## School CSV file has School Name, Address and Population - but we do not need the Principal's name
for (i in 1:length(schoolsCsv$School.Name)) {
  schools$name[[i]] <- as.character(schoolsCsv$School.Name[[i]])
  schools$address[[i]] <- as.character(schoolsCsv$Address[[i]])
  schools$population[[i]] <- as.numeric(schoolsCsv$Student.Population[[i]])
}

## Primary School XLS file has School Name and Address - but it splits the population into male and female students
## Therefore we need to add these together to find totla population
numSchools <- length(schools$name)
for (i in 1:length(schoolsXls$SchoolName)) {
  schools$name[[numSchools+i]] <- as.character(schoolsXls$SchoolName[[i]])
  schools$address[[numSchools+i]] <- as.character(schoolsXls$Address[[i]])
  
  numMales <- as.numeric(schoolsXls$NumMaleStudents[[i]]) 
  numFemales <- as.numeric(schoolsXls$NumFemaleStudents[[i]])
  schools$population[[numSchools+i]] <- numMales + numFemales
}

# PUSH
## Now we need to push our data to ActivityInfo
## Our Form details are:
## - FORM ID: a2145511770
## -> PARTNER FIELD ID: a21455117700000000007 ("Default" Partner is "P0000009909:p0000019616")
## -> SCHOOL NAME FIELD ID: i0580111138
## -> SCHOOL ADDRESS FIELD ID: i0512511085
## -> SCHOOL POPULATION FIELD ID: i1915513273

defaultPartner <- "P0000009909:p0000019616"

changes <- list()
for (i in 1:length(schools$name)) {
  # Generate a random number for record id
  recordId <- sprintf("s%010d", generateId())

  # Generate a Form Record for each school on the list
  changes[[i]] <- list(
    deleted = FALSE,
    recordId = recordId,
    formId = "a2145511770",
    fields = list(
      a21455117700000000007 = defaultPartner,
      i0580111138 = schools$name[[i]],
      i0512511085 = schools$address[[i]],
      i1915513273 = schools$population[[i]]
    )
  )
}

# Send the request to ActivityInfo
requestBody <- list(changes = changes)
activityinfo::postResource("update", requestBody)
