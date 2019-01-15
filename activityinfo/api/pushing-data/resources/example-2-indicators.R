library("activityinfo")

# EXTRACT
## Our "Disaggregated Indicator Form" reports on individuals reached, disaggregated by Gender (Male/Female) and Age (Under 18, Over 18)
## Our Form details are:
## - FORM ID: a2145511771
## -> Partner: a21455117710000000007 ("Default" Partner is "P0000009909:p0000019616")
## -> "# Females under 18": i0932595027
## -> "# Females over 18": i0842756159
## -> "# Males under 18": i0717135643
## -> "# Males over 18": i0785236198
## -> "Reported On": i0773032325

columns <- list(
  femalesUnder18 = "i0932595027",
  femalesOver18 = "i0842756159",
  malesUnder18 = "i0717135643",
  malesOver18 = "i0785236198",
  reportedOn = "i0773032325"
)
data <- queryTable("a2145511771", columns)

# TRANSFORM
## We are required to report on the: 
## - Total # Individuals Reached,
## - Estimated # Households Reached (determined by Total # Individuals Reached / 4)
## - Date Reported
## - Reporting Organisation. We are reporting under "Reporting Partner" ("P0000009909:p0000021297")

## Need to transform our data into the total number of individuals reached and the estimated households reached,a nd keep the reported on date
dataToPush <- list(
  totalIndividuals = list(),
  estimatedHouseholds = list(),
  reportedOn = list(),
  reportedBy = list()
)

reportingPartner <- "P0000009909:p0000021297"

for (i in 1:length(data$reportedOn)) {
  totalIndividuals <- data$femalesUnder18[[i]] + data$femalesOver18[[i]] + data$malesUnder18[[i]] + data$malesOver18[[i]]
  estimatedHouseholds <- totalIndividuals / 4
  
  dataToPush$totalIndividuals[[i]] <- totalIndividuals
  dataToPush$estimatedHouseholds[[i]] <- estimatedHouseholds
  dataToPush$reportedOn[[i]] <- data$reportedOn[[i]]
  dataToPush$reportedBy[[i]] <- reportingPartner
}

# PUSH
## Now we need to push our data to ActivityInfo
## Our Form details are:
## - FORM ID: a2145511772
## -> "# Individuals Reached": i1207228298
## -> "Estimated # Households Reached": i1261093144
## -> "Reported By": a21455117720000000007
## -> "Reported On": i0568437033
## -> "Comments from Reporter": i0274473549

changes <- list()
for (i in 1:length(dataToPush$reportedOn)) {
  # Generate a random number for record id
  recordId <- sprintf("s%010d", generateId())

  # Generate a Form Record for report
  changes[[i]] <- list(
    deleted = FALSE,
    recordId = recordId,
    formId = "a2145511772",
    fields = list(
      i1207228298 = dataToPush$totalIndividuals[[i]],
      i1261093144 = dataToPush$estimatedHouseholds[[i]],
      a21455117720000000007 = dataToPush$reportedBy[[i]],
      i0568437033 = dataToPush$reportedOn[[i]],
      i0274473549 = "Automatic Push from Form a2145511771"
    )
  )
}

# Send the request to ActivityInfo
requestBody <- list(changes = changes)
activityinfo::postResource("update", requestBody)
