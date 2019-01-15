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
## We need to report in the Monthly Sub-Form, under the "Reporting Partner" Parent Record

## Need to transform our data into the total number of individuals reached and the estimated households reached, and keep the reported on date
dataToPush <- list(
  totalIndividuals = list(),
  estimatedHouseholds = list(),
  period = list()
)

for (i in 1:length(data$reportedOn)) {
  totalIndividuals <- data$femalesUnder18[[i]] + data$femalesOver18[[i]] + data$malesUnder18[[i]] + data$malesOver18[[i]]
  estimatedHouseholds <- totalIndividuals / 4
  
  dataToPush$totalIndividuals[[i]] <- totalIndividuals
  dataToPush$estimatedHouseholds[[i]] <- estimatedHouseholds
  
  # Reported On date is 'YYYY-MM-DD", Monthly Period is "YYYY-MM" 
  dataToPush$period[[i]] <- substr(data$reportedOn[[i]], 1, 7)
}

# PUSH
## Now we need to push our data to ActivityInfo
## Our Form details are:
## - MONTHLY SUB-FORM ID: cjqxowoiy1
## -> "Month": period 
## -> "# Individuals Reached": i0154435852
## -> "Estimated # Households Reached": i1271761982
## -> "Comments from Reporter": i0900025586

subFormId <- "cjqxowoiy1"
parentRecordId <- "s1141246439"

changes <- list()
for (i in 1:length(dataToPush$period)) {
  # Generate a random number for record id
  recordId <- sprintf("s%010d", generateId())

  # Generate a Form Record for report
  changes[[i]] <- list(
    deleted = FALSE,
    recordId = recordId,
    formId = subFormId,
    parentRecordId = parentRecordId,
    fields = list(
      period = dataToPush$period[[i]],
      i0154435852 = dataToPush$totalIndividuals[[i]],
      i1271761982 = dataToPush$estimatedHouseholds[[i]],
      i0900025586 = "Automatic Push from Form a2145511771"
    )
  )
}

# Send the request to ActivityInfo
requestBody <- list(changes = changes)
activityinfo::postResource("update", requestBody)
