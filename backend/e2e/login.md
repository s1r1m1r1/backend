// 
// user/login
//
curl -s -L -X POST 'http://localhost:8080/users/login' -H 'Content-Type: application/json' --data-raw '{
    "email":"saileshbro@gmail.com",
    "password":"6aMj@UBByu%7BzN^C9tMe#Te4b!4cJrXwwFi#HgKrQ&g&ddNN6eHQ94vd5SuJtEc%7^H6L^xews8soG@R7GnW*RvfJVMaKEuBXNtVtbP5!3^qs*n!Z%87q8eRJmKFUHg"
}'

response
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjQ4ODY5Yjc4LWEwMjgtNGMwNS1hN2QzLTQ5OTQ2Mzk4NDI2NSIsIm5hbWUiOiJTYWlsZXNoIERhaGFsIiwiZW1haWwiOiJzYWlsZXNoQGdtYWlsLmNvbSIsImNyZWF0ZWRfYXQiOiIyMDIzLTAxLTMwVDA5OjU3OjQ5LjExODM2MVoiLCJwYXNzd29yZCI6IiQyYSQxMCRGSDVDc2N1Y0VuLlNwWlZmSWFtRGwuZzRMaDFhd2ltbVRMS05yU2NORW1qT25lSFZHOE4wLiIsImlhdCI6MTY3NTA2MDA0MH0.qvzLWgAEphlYqZztoBf7Bvag6hO1qkp44hUwl78CMVo",
  "user": {
    "id": "48869b78-a028-4c05-a7d3-499463984265",
    "name": "Sailesh Dahal",
    "email": "saileshbro@gmail.com",
    "created_at": "2023-01-30T09:57:49.118361Z"
  }
}

//-----------------------------------------------------------------------------------------------------------------------------------------------
// user/login

curl -s -L -X POST 'http://localhost:8080/users/login' -H 'Content-Type: application/json' --data-raw '{
    "email":"sa@gmail.com",
    "name":"Sailesh Dahal",
    "password":"6aMj@UBByu%7BzN^C9tMe#Te4b!4cJrXwwFi#HgKrQ&g&ddNN6eHQ94vd5SuJtEc%7^H6L^xews8soG@R7GnW*RvfJVMaKEuBXNtVtbP5!3^qs*n!Z%87q8eRJmKFUHg"
}'


reponse
{ "message": "Invalid email or password" }

//---------------------------------------------------------------------------------------------------------------------------------------------
// user/signup

curl -s -L -X POST 'http://localhost:8080/users/signup' -H 'Content-Type: application/json' --data-raw '{
    "email":"sailes@gmail.com",
    "password":"6aMj@UBByu"
}'

response
{
  "message": "Validation failed",
  "errors": {
    "name": ["Name is required"]
  }
}
<!--  -->
curl -s -L -X POST 'http://localhost:8080/users/signup' -H 'Content-Type: application/json' --data-raw '{
  "name": "testname",
    "email":"sailes@gmail.com",
    "password":"6aMj@UBByu"
}'

//---------------------------------------------------------------------------------------------------------------------------------------------
curl -s -L -X POST 'http://localhost:8080/users/login' -H 'Content-Type: application/json' --data-raw '{
  "name": "testname",
    "email":"sailes@gmail.com",
    "password":"6aMj@UBByu"
}'

6aMj@UBByu