** This is for home screen where dashboards are rendered:

** API below will fetch all dashbborads based on basic authentication of user(admin:district)

https://play.im.dhis2.org/dev/api/dashboards?paging=false  
 
 {
    "dashboards": [
        {
            "displayName": "Antenatal Care",
            "id": "nghVC4wtyzi"
        },
        {
            "displayName": "Cases Malaria",
            "id": "JW7RlN5xafN"
        },
        {
            "displayName": "Delivery",
            "id": "iMnYyBfSxmM"
        },
        {
            "displayName": "Disease Surveillance",
            "id": "vqh4MBWOTi4"
        },
        {
            "displayName": "EE maps",
            "id": "Goz4vyRx2cy"
        },
        {
            "displayName": "Immunization",
            "id": "TAMlzYkstb7"
        },
        {
            "displayName": "Immunization data",
            "id": "L1BtjXgpUpd"
        },
        {
            "displayName": "Info Videos",
            "id": "SCtS6Szuubz"
        },
        {
            "displayName": "Inpatient BMI, Weight and Height",
            "id": "uGSg3NSw6TZ"
        },
        {
            "displayName": "Inpatient Discharge",
            "id": "eZSIccgeq94"
        },
        {
            "displayName": "Inpatient Morbidity Mortality",
            "id": "zbKnj1SCmB4"
        },
        {
            "displayName": "Inpatient Visit Overview",
            "id": "nTTLMwiwoys"
        },
        {
            "displayName": "Key Indicators",
            "id": "xP1jtPjus1c"
        },
        {
            "displayName": "Malnutrition",
            "id": "tCMKwn5YUXt"
        },
        {
            "displayName": "Measles (user org unit)",
            "id": "KQVXh5tlzW2"
        },
        {
            "displayName": "Mother and Child Health",
            "id": "vQFhmLJU5sK"
        },
        {
            "displayName": "Nutrition",
            "id": "nAZMjkQChz8"
        },
        {
            "displayName": "Reporting Rates",
            "id": "oW3XL9FfSTq"
        },
        {
            "displayName": "Reporting Reproductive Health",
            "id": "MBUMbG6zJIj"
        },
        {
            "displayName": "Staffing",
            "id": "a68enp54saw"
        },
        {
            "displayName": "Top Contacts",
            "id": "eCp1qIWRUrf"
        },
        {
            "displayName": "Visits ANC",
            "id": "juY8oe5lg4g"
        }
    ]
}

**From that we can fetch details for specific dashboard based on its id as shown by API below:

https://play.im.dhis2.org/dev/api/dashboards/nghVC4wtyzi

{
    "created": "2013-09-08T21:47:17.960",
    "lastUpdated": "2024-12-07T18:46:25.375",
    "lastUpdatedBy": {
        "id": "GOLswS44mh8",
        "code": null,
        "name": "Tom Wakiki",
        "displayName": "Tom Wakiki",
        "username": "system"
    },
    "createdBy": {
        "id": "GOLswS44mh8",
        "code": null,
        "name": "Tom Wakiki",
        "displayName": "Tom Wakiki",
        "username": "system"
    },
    "href": "https://play.im.dhis2.org/dev/api/dashboards/nghVC4wtyzi",
    "name": "Antenatal Care",
    "restrictFilters": false,
    "allowedFilters": [],
    "sharing": {
        "owner": "GOLswS44mh8",
        "users": {},
        "userGroups": {},
        "public": "rw------"
    },
    "favorites": [
        "xE7jOejl9FI"
    ],
    "translations": [],
    "displayName": "Antenatal Care",
    "access": {
        "manage": true,
        "write": true,
        "read": true,
        "update": true,
        "delete": true
    },
    "itemCount": 11,
    "user": {
        "id": "GOLswS44mh8",
        "code": null,
        "name": "Tom Wakiki",
        "displayName": "Tom Wakiki",
        "username": "system"
    },
    "favorite": true,
    "id": "nghVC4wtyzi",
    "dashboardItems": [
        {
            "visualization": {
                "id": "xiLNqnSaWP3"
            },
            "users": [],
            "x": 16,
            "y": 20,
            "height": 20,
            "width": 19,
            "translations": [],
            "created": "2024-12-07T18:46:24.918",
            "lastUpdated": "2024-12-07T18:46:25.377",
            "interpretationCount": 0,
            "interpretationLikeCount": 0,
            "contentCount": 1,
            "href": "/dashboardItems/rOehBDv4LGG",
            "type": "VISUALIZATION",
            "access": {
                "manage": true,
                "write": true,
                "read": true,
                "update": true,
                "delete": true
            },
            "reports": [],
            "resources": [],
            "id": "rOehBDv4LGG"
        },
        {
            "text": "*ANC Overview*\n\nThe ANC dashboard provides a _comprehensive_ overview of ANC activity.\n\nClick on the *arrow* next to each item to explore the data further.\n\nYou can switch between visualization types by clicking on the table/chart/map icons for each item.",
            "users": [],
            "x": 0,
            "y": 0,
            "height": 20,
            "width": 9,
            "translations": [],
            "created": "2024-12-07T18:46:24.918",
            "lastUpdated": "2024-12-07T18:46:25.377",
            "interpretationCount": 0,
            "interpretationLikeCount": 0,
            "contentCount": 1,
            "displayText": "*ANC Overview*\n\nThe ANC dashboard provides a _comprehensive_ overview of ANC activity.\n\nClick on the *arrow* next to each item to explore the data further.\n\nYou can switch between visualization types by clicking on the table/chart/map icons for each item.",
            "href": "/dashboardItems/ILRTXgXvurM",
            "type": "TEXT",
            "access": {
                "manage": true,
                "write": true,
                "read": true,
                "update": true,
                "delete": true
            },
            "reports": [],
            "resources": [],
            "id": "ILRTXgXvurM"
        },
        {
            "visualization": {
                "id": "YCra7cCtsw9"
            },
            "users": [],
            "x": 0,
            "y": 40,
            "height": 20,
            "width": 30,
            "translations": [],
            "created": "2024-12-07T18:46:24.918",
            "lastUpdated": "2024-12-07T18:46:25.378",
            "interpretationCount": 0,
            "interpretationLikeCount": 0,
            "contentCount": 1,
            "href": "/dashboardItems/Mfc8okt2ACJ",
            "type": "VISUALIZATION",
            "access": {
                "manage": true,
                "write": true,
                "read": true,
                "update": true,
                "delete": true
            },
            "reports": [],
            "resources": [],
            "id": "Mfc8okt2ACJ"
        },
        {
            "visualization": {
                "id": "DeRrc1gTMjn"
            },
            "users": [],
            "x": 9,
            "y": 0,
            "height": 20,
            "width": 26,
            "translations": [],
            "created": "2024-12-07T18:46:24.918",
            "lastUpdated": "2024-12-07T18:46:25.380",
            "interpretationCount": 1,
            "interpretationLikeCount": 0,
            "contentCount": 1,
            "href": "/dashboardItems/azz0KRlHgLs",
            "type": "VISUALIZATION",
            "access": {
                "manage": true,
                "write": true,
                "read": true,
                "update": true,
                "delete": true
            },
            "reports": [],
            "resources": [],
            "id": "azz0KRlHgLs"
        },
        {
            "map": {
                "id": "voX07ulo2Bq"
            },
            "users": [],
            "shape": "NORMAL",
            "x": 0,
            "y": 20,
            "height": 20,
            "width": 16,
            "translations": [],
            "created": "2024-12-07T18:46:24.918",
            "lastUpdated": "2024-12-07T18:46:25.392",
            "interpretationCount": 0,
            "interpretationLikeCount": 0,
            "contentCount": 1,
            "href": "/dashboardItems/i6NTSuDsk6l",
            "type": "MAP",
            "access": {
                "manage": true,
                "write": true,
                "read": true,
                "update": true,
                "delete": true
            },
            "reports": [],
            "resources": [],
            "id": "i6NTSuDsk6l"
        },
        {
            "map": {
                "id": "ZBjCfSaLSqD"
            },
            "users": [],
            "shape": "NORMAL",
            "x": 35,
            "y": 0,
            "height": 20,
            "width": 25,
            "translations": [],
            "created": "2024-12-07T18:46:24.918",
            "lastUpdated": "2024-12-07T18:46:25.392",
            "interpretationCount": 1,
            "interpretationLikeCount": 0,
            "contentCount": 1,
            "href": "/dashboardItems/OiyMNoXzSdY",
            "type": "MAP",
            "access": {
                "manage": true,
                "write": true,
                "read": true,
                "update": true,
                "delete": true
            },
            "reports": [],
            "resources": [],
            "id": "OiyMNoXzSdY"
        },
        {
            "visualization": {
                "id": "zKl0LcQyxPl"
            },
            "users": [],
            "shape": "DOUBLE_WIDTH",
            "x": 30,
            "y": 40,
            "height": 20,
            "width": 30,
            "translations": [],
            "created": "2024-12-07T18:46:24.918",
            "lastUpdated": "2024-12-07T18:46:25.393",
            "interpretationCount": 0,
            "interpretationLikeCount": 0,
            "contentCount": 1,
            "href": "/dashboardItems/YZ7U25Japom",
            "type": "VISUALIZATION",
            "access": {
                "manage": true,
                "write": true,
                "read": true,
                "update": true,
                "delete": true
            },
            "reports": [],
            "resources": [],
            "id": "YZ7U25Japom"
        },
        {
            "visualization": {
                "id": "hQxZGXqnLS9"
            },
            "users": [],
            "shape": "NORMAL",
            "x": 30,
            "y": 60,
            "height": 20,
            "width": 30,
            "translations": [],
            "created": "2024-12-07T18:46:24.918",
            "lastUpdated": "2024-12-07T18:46:25.393",
            "interpretationCount": 0,
            "interpretationLikeCount": 0,
            "contentCount": 1,
            "href": "/dashboardItems/ctlS5cTa4tt",
            "type": "VISUALIZATION",
            "access": {
                "manage": true,
                "write": true,
                "read": true,
                "update": true,
                "delete": true
            },
            "reports": [],
            "resources": [],
            "id": "ctlS5cTa4tt"
        },
        {
            "visualization": {
                "id": "ZfQMIA4o2s3"
            },
            "users": [],
            "shape": "NORMAL",
            "x": 0,
            "y": 60,
            "height": 20,
            "width": 15,
            "translations": [],
            "created": "2024-12-07T18:46:24.918",
            "lastUpdated": "2024-12-07T18:46:25.393",
            "interpretationCount": 0,
            "interpretationLikeCount": 0,
            "contentCount": 1,
            "href": "/dashboardItems/kHRSFUr3dYe",
            "type": "VISUALIZATION",
            "access": {
                "manage": true,
                "write": true,
                "read": true,
                "update": true,
                "delete": true
            },
            "reports": [],
            "resources": [],
            "id": "kHRSFUr3dYe"
        },
        {
            "visualization": {
                "id": "NjK24B1oGYF"
            },
            "users": [],
            "shape": "DOUBLE_WIDTH",
            "x": 35,
            "y": 20,
            "height": 20,
            "width": 25,
            "translations": [],
            "created": "2024-12-07T18:46:24.919",
            "lastUpdated": "2024-12-07T18:46:25.393",
            "interpretationCount": 0,
            "interpretationLikeCount": 0,
            "contentCount": 1,
            "href": "/dashboardItems/tgtgBRAPNUT",
            "type": "VISUALIZATION",
            "access": {
                "manage": true,
                "write": true,
                "read": true,
                "update": true,
                "delete": true
            },
            "reports": [],
            "resources": [],
            "id": "tgtgBRAPNUT"
        },
        {
            "visualization": {
                "id": "AVZpYsdG44G"
            },
            "users": [],
            "shape": "NORMAL",
            "x": 15,
            "y": 60,
            "height": 20,
            "width": 15,
            "translations": [],
            "created": "2024-12-07T18:46:24.919",
            "lastUpdated": "2024-12-07T18:46:25.394",
            "interpretationCount": 0,
            "interpretationLikeCount": 0,
            "contentCount": 1,
            "href": "/dashboardItems/xS4X0ZL6GCI",
            "type": "VISUALIZATION",
            "access": {
                "manage": true,
                "write": true,
                "read": true,
                "update": true,
                "delete": true
            },
            "reports": [],
            "resources": [],
            "id": "xS4X0ZL6GCI"
        }
    ],
    "attributeValues": []
}

**As we seen each dashboard contains items and visualizations, now lets fetch their details by its is as shown by API below:

https://play.im.dhis2.org/dev/api/visualizations/xiLNqnSaWP3

{
    "name": "ANC: Coverage by quarter and district (two-category)",
    "created": "2021-08-11T20:26:40.055",
    "lastUpdated": "2024-12-07T18:46:38.289",
    "translations": [],
    "createdBy": {
        "id": "GOLswS44mh8",
        "code": null,
        "name": "Tom Wakiki",
        "displayName": "Tom Wakiki",
        "username": "system"
    },
    "favorites": [],
    "lastUpdatedBy": {
        "id": "GOLswS44mh8",
        "code": null,
        "name": "Tom Wakiki",
        "displayName": "Tom Wakiki",
        "username": "system"
    },
    "sharing": {
        "owner": "GOLswS44mh8",
        "users": {
            "xE7jOejl9FI": {
                "displayName": "John Traore",
                "access": "rw------",
                "id": "xE7jOejl9FI"
            }
        },
        "userGroups": {},
        "public": "rw------"
    },
    "regressionType": "NONE",
    "displayDensity": "NORMAL",
    "fontSize": "NORMAL",
    "rawPeriods": [
        "LAST_4_QUARTERS"
    ],
    "sortOrder": 0,
    "topLimit": 0,
    "hideEmptyRows": false,
    "showHierarchy": false,
    "userOrganisationUnit": false,
    "userOrganisationUnitChildren": false,
    "userOrganisationUnitGrandChildren": false,
    "completedOnly": false,
    "skipRounding": false,
    "filterDimensions": [],
    "dataDimensionItems": [
        {
            "indicator": {
                "id": "Uvn6LCg7dVU"
            },
            "dataDimensionItemType": "INDICATOR"
        },
        {
            "indicator": {
                "id": "OdiHJayrsKo"
            },
            "dataDimensionItemType": "INDICATOR"
        }
    ],
    "organisationUnits": [
        {
            "id": "O6uvpzGd5pu"
        },
        {
            "id": "fdc6uOvgoji"
        },
        {
            "id": "lc3eMKXaEfw"
        },
        {
            "id": "jUb8gELQApl"
        },
        {
            "id": "PMa2VCrupOd"
        }
    ],
    "dataElementGroupSetDimensions": [],
    "organisationUnitGroupSetDimensions": [],
    "organisationUnitLevels": [],
    "categoryDimensions": [],
    "categoryOptionGroupSetDimensions": [],
    "attributeDimensions": [],
    "dataElementDimensions": [],
    "programIndicatorDimensions": [],
    "itemOrganisationUnitGroups": [],
    "subscribers": [],
    "aggregationType": "DEFAULT",
    "digitGroupSeparator": "SPACE",
    "hideEmptyRowItems": "NONE",
    "hideLegend": false,
    "noSpaceBetweenColumns": false,
    "cumulativeValues": false,
    "percentStackedValues": false,
    "showData": true,
    "colTotals": false,
    "rowTotals": false,
    "rowSubTotals": false,
    "colSubTotals": false,
    "hideTitle": false,
    "hideSubtitle": false,
    "showDimensionLabels": false,
    "interpretations": [],
    "type": "COLUMN",
    "reportingParams": {
        "grandParentOrganisationUnit": false,
        "parentOrganisationUnit": false,
        "organisationUnit": false,
        "reportingPeriod": false
    },
    "columnDimensions": [
        "dx"
    ],
    "rowDimensions": [
        "pe",
        "ou"
    ],
    "numberType": "VALUE",
    "fontStyle": {},
    "colorSet": "DEFAULT",
    "yearlySeries": [],
    "regression": false,
    "hideEmptyColumns": false,
    "fixColumnHeaders": false,
    "fixRowHeaders": false,
    "filters": [],
    "parentGraphMap": {
        "jUb8gELQApl": "ImspTQPwCqd",
        "PMa2VCrupOd": "ImspTQPwCqd",
        "O6uvpzGd5pu": "ImspTQPwCqd",
        "lc3eMKXaEfw": "ImspTQPwCqd",
        "fdc6uOvgoji": "ImspTQPwCqd"
    },
    "metaData": {
        "jUb8gELQApl": {
            "uid": "jUb8gELQApl",
            "code": "OU_204856",
            "name": "Kailahun"
        },
        "PMa2VCrupOd": {
            "uid": "PMa2VCrupOd",
            "code": "OU_211212",
            "name": "Kambia"
        },
        "O6uvpzGd5pu": {
            "uid": "O6uvpzGd5pu",
            "code": "OU_264",
            "name": "Bo"
        },
        "lc3eMKXaEfw": {
            "uid": "lc3eMKXaEfw",
            "code": "OU_197385",
            "name": "Bonthe"
        },
        "fdc6uOvgoji": {
            "uid": "fdc6uOvgoji",
            "code": "OU_193190",
            "name": "Bombali"
        }
    },
    "columns": [
        {
            "id": "dx"
        }
    ],
    "rows": [
        {
            "id": "pe"
        },
        {
            "id": "ou"
        }
    ],
    "subscribed": false,
    "displayName": "ANC: Coverage by quarter and district (two-category)",
    "access": {
        "manage": true,
        "write": true,
        "read": true,
        "update": true,
        "delete": true
    },
    "user": {
        "id": "GOLswS44mh8",
        "code": null,
        "name": "Tom Wakiki",
        "displayName": "Tom Wakiki",
        "username": "system"
    },
    "href": "https://play.im.dhis2.org/dev/api/visualizations/xiLNqnSaWP3",
    "displayFormName": "ANC: Coverage by quarter and district (two-category)",
    "favorite": false,
    "id": "xiLNqnSaWP3",
    "attributeValues": [],
    "relativePeriods": {
        "thisDay": false,
        "yesterday": false,
        "last3Days": false,
        "last7Days": false,
        "last14Days": false,
        "last30Days": false,
        "last60Days": false,
        "last90Days": false,
        "last180Days": false,
        "thisMonth": false,
        "lastMonth": false,
        "thisBimonth": false,
        "lastBimonth": false,
        "thisQuarter": false,
        "lastQuarter": false,
        "thisSixMonth": false,
        "lastSixMonth": false,
        "weeksThisYear": false,
        "monthsThisYear": false,
        "biMonthsThisYear": false,
        "quartersThisYear": false,
        "thisYear": false,
        "monthsLastYear": false,
        "quartersLastYear": false,
        "lastYear": false,
        "last5Years": false,
        "last10Years": false,
        "last12Months": false,
        "last6Months": false,
        "last3Months": false,
        "last6BiMonths": false,
        "last4Quarters": true,
        "last2SixMonths": false,
        "thisFinancialYear": false,
        "lastFinancialYear": false,
        "last5FinancialYears": false,
        "last10FinancialYears": false,
        "thisWeek": false,
        "lastWeek": false,
        "thisBiWeek": false,
        "lastBiWeek": false,
        "last4Weeks": false,
        "last4BiWeeks": false,
        "last12Weeks": false,
        "last52Weeks": false
    },
    "legend": {
        "showKey": false
    },
    "sorting": [],
    "series": [],
    "optionalAxes": [],
    "icons": [],
    "seriesKey": {
        "hidden": false
    },
    "axes": [],
    "periods": []
}



**Response above contains details necesary for rendering UI(chart), details contained are
-Chart Type: COLUMN

Indicators:
- Uvn6LCg7dVU
- OdiHJayrsKo

Periods:
- LAST_4_QUARTERS

Organisation Units:
- Bo
- Bombali
- Bonthe
- Kailahun
- Kambia

**but its lacks the actual chart data, now lets fetch them according to their details(definition) above as shown by API below

https://play.im.dhis2.org/dev/api/analytics.json?dimension=dx:Uvn6LCg7dVU;OdiHJayrsKo&dimension=pe:LAST_4_QUARTERS&dimension=ou:O6uvpzGd5pu;fdc6uOvgoji;lc3eMKXaEfw;jUb8gELQApl;PMa2VCrupOd

{
    "headers": [
        {
            "name": "dx",
            "column": "Data",
            "valueType": "TEXT",
            "type": "java.lang.String",
            "hidden": false,
            "meta": true
        },
        {
            "name": "pe",
            "column": "Period",
            "valueType": "TEXT",
            "type": "java.lang.String",
            "hidden": false,
            "meta": true
        },
        {
            "name": "ou",
            "column": "Organisation unit",
            "valueType": "TEXT",
            "type": "java.lang.String",
            "hidden": false,
            "meta": true
        },
        {
            "name": "value",
            "column": "Value",
            "valueType": "NUMBER",
            "type": "java.lang.Double",
            "hidden": false,
            "meta": false
        }
    ],
    "metaData": {
        "items": {
            "jUb8gELQApl": {
                "name": "Kailahun"
            },
            "PMa2VCrupOd": {
                "name": "Kambia"
            },
            "ou": {
                "name": "Organisation unit"
            },
            "OdiHJayrsKo": {
                "name": "ANC 2 Coverage"
            },
            "O6uvpzGd5pu": {
                "name": "Bo"
            },
            "2025Q4": {
                "name": "October - December 2025"
            },
            "2026Q1": {
                "name": "January - March 2026"
            },
            "2025Q3": {
                "name": "July - September 2025"
            },
            "2026Q2": {
                "name": "April - June 2026"
            },
            "fdc6uOvgoji": {
                "name": "Bombali"
            },
            "dx": {
                "name": "Data"
            },
            "pe": {
                "name": "Period"
            },
            "LAST_4_QUARTERS": {
                "name": "Last 4 quarters"
            },
            "Uvn6LCg7dVU": {
                "name": "ANC 1 Coverage"
            },
            "lc3eMKXaEfw": {
                "name": "Bonthe"
            }
        },
        "dimensions": {
            "dx": [
                "Uvn6LCg7dVU",
                "OdiHJayrsKo"
            ],
            "pe": [
                "2025Q3",
                "2025Q4",
                "2026Q1",
                "2026Q2"
            ],
            "ou": [
                "O6uvpzGd5pu",
                "fdc6uOvgoji",
                "lc3eMKXaEfw",
                "jUb8gELQApl",
                "PMa2VCrupOd"
            ],
            "co": []
        }
    },
    "rowContext": {},
    "width": 4,
    "rows": [
        [
            "Uvn6LCg7dVU",
            "2025Q3",
            "O6uvpzGd5pu",
            "158.96"
        ],
        [
            "Uvn6LCg7dVU",
            "2025Q3",
            "fdc6uOvgoji",
            "88.79"
        ],
        [
            "Uvn6LCg7dVU",
            "2025Q3",
            "lc3eMKXaEfw",
            "117.95"
        ],
        [
            "Uvn6LCg7dVU",
            "2025Q3",
            "jUb8gELQApl",
            "84.67"
        ],
        [
            "Uvn6LCg7dVU",
            "2025Q3",
            "PMa2VCrupOd",
            "97.7"
        ],
        [
            "Uvn6LCg7dVU",
            "2025Q4",
            "O6uvpzGd5pu",
            "149.13"
        ],
        [
            "Uvn6LCg7dVU",
            "2025Q4",
            "fdc6uOvgoji",
            "54.48"
        ],
        [
            "Uvn6LCg7dVU",
            "2025Q4",
            "lc3eMKXaEfw",
            "35.77"
        ],
        [
            "Uvn6LCg7dVU",
            "2025Q4",
            "jUb8gELQApl",
            "77.37"
        ],
        [
            "Uvn6LCg7dVU",
            "2025Q4",
            "PMa2VCrupOd",
            "109.41"
        ],
        [
            "Uvn6LCg7dVU",
            "2026Q1",
            "O6uvpzGd5pu",
            "129.5"
        ],
        [
            "Uvn6LCg7dVU",
            "2026Q1",
            "fdc6uOvgoji",
            "83.96"
        ],
        [
            "Uvn6LCg7dVU",
            "2026Q1",
            "lc3eMKXaEfw",
            "91.53"
        ],
        [
            "Uvn6LCg7dVU",
            "2026Q1",
            "jUb8gELQApl",
            "78.25"
        ],
        [
            "Uvn6LCg7dVU",
            "2026Q1",
            "PMa2VCrupOd",
            "98.03"
        ],
        [
            "Uvn6LCg7dVU",
            "2026Q2",
            "O6uvpzGd5pu",
            "143.51"
        ],
        [
            "Uvn6LCg7dVU",
            "2026Q2",
            "fdc6uOvgoji",
            "104.64"
        ],
        [
            "Uvn6LCg7dVU",
            "2026Q2",
            "lc3eMKXaEfw",
            "118.15"
        ],
        [
            "Uvn6LCg7dVU",
            "2026Q2",
            "jUb8gELQApl",
            "89.23"
        ],
        [
            "Uvn6LCg7dVU",
            "2026Q2",
            "PMa2VCrupOd",
            "110.35"
        ],
        [
            "OdiHJayrsKo",
            "2025Q3",
            "O6uvpzGd5pu",
            "153.3"
        ],
        [
            "OdiHJayrsKo",
            "2025Q3",
            "fdc6uOvgoji",
            "75.16"
        ],
        [
            "OdiHJayrsKo",
            "2025Q3",
            "lc3eMKXaEfw",
            "117.57"
        ],
        [
            "OdiHJayrsKo",
            "2025Q3",
            "jUb8gELQApl",
            "84.13"
        ],
        [
            "OdiHJayrsKo",
            "2025Q3",
            "PMa2VCrupOd",
            "94.85"
        ],
        [
            "OdiHJayrsKo",
            "2025Q4",
            "O6uvpzGd5pu",
            "132.44"
        ],
        [
            "OdiHJayrsKo",
            "2025Q4",
            "fdc6uOvgoji",
            "51.25"
        ],
        [
            "OdiHJayrsKo",
            "2025Q4",
            "lc3eMKXaEfw",
            "35.44"
        ],
        [
            "OdiHJayrsKo",
            "2025Q4",
            "jUb8gELQApl",
            "83.28"
        ],
        [
            "OdiHJayrsKo",
            "2025Q4",
            "PMa2VCrupOd",
            "95.25"
        ],
        [
            "OdiHJayrsKo",
            "2026Q1",
            "O6uvpzGd5pu",
            "127.0"
        ],
        [
            "OdiHJayrsKo",
            "2026Q1",
            "fdc6uOvgoji",
            "73.9"
        ],
        [
            "OdiHJayrsKo",
            "2026Q1",
            "lc3eMKXaEfw",
            "85.11"
        ],
        [
            "OdiHJayrsKo",
            "2026Q1",
            "jUb8gELQApl",
            "76.85"
        ],
        [
            "OdiHJayrsKo",
            "2026Q1",
            "PMa2VCrupOd",
            "91.88"
        ],
        [
            "OdiHJayrsKo",
            "2026Q2",
            "O6uvpzGd5pu",
            "156.54"
        ],
        [
            "OdiHJayrsKo",
            "2026Q2",
            "fdc6uOvgoji",
            "85.13"
        ],
        [
            "OdiHJayrsKo",
            "2026Q2",
            "lc3eMKXaEfw",
            "110.35"
        ],
        [
            "OdiHJayrsKo",
            "2026Q2",
            "jUb8gELQApl",
            "97.94"
        ],
        [
            "OdiHJayrsKo",
            "2026Q2",
            "PMa2VCrupOd",
            "97.67"
        ]
    ],
    "headerWidth": 4,
    "height": 40
}

