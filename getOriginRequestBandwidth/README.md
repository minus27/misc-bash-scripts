# Get Origin Request Bandwidth CLI Scripts
This is a collection of 3 bash scripts for Mac OS X which can be used to get the total origin (i.e. backend) request bandwidth of all of a customer's Services over a specified time window:

- `getServices` - gets the Service ID's and Service names for an Account based on the given Customer ID
- `processSidFile` - reads a file of Service ID's and gets the total origin request bandwidth for each over a given time window
- `getBackendRequestBytes` - gets the total origin request bandwidth for a Service over a given time window based on the given Service ID

Note: `getBackendRequestBytes` is called by `processSidFile`, but can be run by itself if desired.

## Requirements
- a Fastly API Key
- a Fastly Customer ID
- `curl` is required for API calls
- `jq` is required for JSON data filtering and overall sanity preservation

## Installation
- Download the script files
- Make the script files executable (`chmod +x SCRIPT_FILE_NAME`)

## Usage
### getServices
```
$ ./getServices
USAGE: getServices API_KEY CUSTOMER_ID
$
```
#### processSidFile
```
$ ./processSidFile
USAGE: processSidFile API_KEY FROM_DATE TO_DATE SERVICE_ID_FILE
       where FROM_DATE and TO_DATE are YYYY-MM-DD

Notes:
       1) The date range starts at FROM_DATE and goes through TO_DATE
       2) Lines starting with a "#" in SERVICE_ID_FILE are ignored

$
```
#### getBackendRequestBytes
```
$ ./getBackendRequestBytes
USAGE: getBackendRequestBytes API_KEY SERVICE_ID FROM_DATE TO_DATE [--debug]
       where FROM_DATE and TO_DATE are YYYY-MM-DD

Note: The date range starts at FROM_DATE and goes through TO_DATE

$
```

## Examples
### 1) Typical execution, i.e. getting and processing all Service ID's for a Customer ID
```
$ ./getServices $API_KEY $CUSTOMER_ID > service_list.csv
$ ./processSidFile $API_KEY 2019-01-01 2019-01-31 service_list.csv > origin_request_bw.csv
$
```
### 2) Getting the origin request bandwidth for a single Service ID
```
$ ./getBackendRequestBytes $API_KEY $SERVICE_ID 2019-01-01 2019-01-31
26375472,"26,375,472","26.375 Mb",""
$
```

## To Do's
TBD
