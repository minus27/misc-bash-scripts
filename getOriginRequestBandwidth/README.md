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
USAGE: getBackendRequestBytes API_KEY SERVICE_ID FROM_DATE TO_DATE [--labels TYPE] [--debug]
       where FROM_DATE and TO_DATE are YYYY-MM-DD
       and TYPE = r[ows] or c[ols]

Note: The date range starts at FROM_DATE and goes through TO_DATE

$
```

## Examples
Note:  `$API_KEY`, `$CUSTOMER_ID`, and `$SERVICE_ID` are bash variables containing
the Fastly API Key, Customer ID, and Service ID, respectively.
### 2) Typical execution, i.e. getting and processing all Service ID's for a Customer ID
```
$ ./getServices $API_KEY $CUSTOMER_ID > service_list.csv
$ ./processSidFile $API_KEY 2019-01-01 2019-06-30 service_list.csv > origin_request_bw.csv
$ cat origin_request_bw.csv
"Service ID","Service Name","Total Bytes","Abbrev. Total Bytes","Shielding?"
"3Amd..................","Service A","0","0 B",""
"2LlQ..................","Service B","136,328","136.328 kB",""
"0mcp..................","Service C","1,585,991","1.585 MB",""
"7SDG..................","Service D","32,164","32.164 kB",""
"0jUO..................","Service E","11,120","11.12 kB",""
"5Wwy..................","Service F","3,015","3.015 kB",""
"4FvH..................","Service G","2,523","2.523 kB",""
"2PXJ..................","Service H","12,849","12.849 kB",""
"1w1Z..................","Service I","23,195","23.195 kB",""
"6AwC..................","Service J","20,441,993","20.441 MB",""
"5H3I..................","Service K","1,105","1.105 kB",""
"3Sj7..................","Service L","16,029,893","16.029 MB","X"
"1yFV..................","Service M","4,855,073","4.855 MB",""
"6yb5..................","Service N","279,564","279.564 kB","X"
"2egR..................","Service O","39,221","39.221 kB",""
"2krw..................","Service P","24,294","24.294 kB","X"
"546u..................","Service Q","394,768","394.768 kB",""
"364N..................","Service R","4,010","4.01 kB",""
"1MWP..................","Service S","61,815","61.815 kB",""
"006f..................","Service T","10,882","10.882 kB",""
"0QuW..................","Service U","5,101","5.101 kB",""
"4Lth..................","Service V","2,760","2.76 kB",""
"pVkj..................","Service W","255,411,345","255.411 MB",""
"09ei..................","Service X","14,258","14.258 kB",""
"0FgM..................","Service Y","833","833 B",""
"13na..................","Service Z","5,099","5.099 kB","

"Total Traffic to Origin = 299,389,199 bytes (299.389 Mb) from 2019-01-01 to 2019-06-30"
$
```

## To Do's
1. Detect which Services currently have WAFs on them
