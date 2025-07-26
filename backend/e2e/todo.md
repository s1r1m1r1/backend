curl -s -L -X GET 'http://localhost:8080/todos'

{
  "message": "Unauthorized"
}
//-------------------------------------------------------------------


curl -s -L -X GET 'http://localhost:8080/todos' -H 'Authorization: Bearer <token>'
curl -s -L -X GET 'http://localhost:8080/todos' -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI4ZDdkZWU1MC02YTRhLTExZjAtOThmNi01NzIyMjYyMDNjNzAiLCJuYW1lIjoidGVzdG5hbWUiLCJlbWFpbCI6InNhaWxlc0BnbWFpbC5jb20iLCJjcmVhdGVkQXQiOiIyMDI1LTA3LTI2VDIwOjAxOjI4LjAwMCIsImlhdCI6MTc1MzU1Mjg5M30.JiUBd2Sb8dtCKjsuEJq0k6gH94waZhk5hte-ADmvJUg'

[
  {
    "id": 76,
    "user_id": "69eade87-da5e-44cd-b54e-474a85d8dee4",
    "title": "this is a title asdf",
    "description": "Not so great description asdf",
    "completed": false,
    "created_at": "2023-01-23T22:56:31.686023Z",
    "updated_at": "2023-01-30T04:08:06.349549Z"
  }
]


//-------------------------------------------------------------------

curl -s -L -X POST 'http://localhost:8080/todos' -H 'Content-Type: application/json' --data-raw '{
    "title":"this is a title asdf",
    "description":"Not so great description asdf"
}'

{
  "message": "Unauthorized"
}

//-------------------------------------------------------------------



curl -s -L -X POST 'http://localhost:8080/todos' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data-raw '{
    "title":"this is a title asdf",
    "description":"Not so great description asdf"
}'


{
  "id": 79,
  "user_id": "69eade87-da5e-44cd-b54e-474a85d8dee4",
  "title": "this is a title asdf",
  "description": "Not so great description asdf",
  "completed": false,
  "created_at": "2023-01-30T07:10:10.102358Z",
  "updated_at": null
}


//-------------------------------------------------------------------




//-------------------------------------------------------------------



//-------------------------------------------------------------------





//-------------------------------------------------------------------
//-------------------------------------------------------------------
//-------------------------------------------------------------------
//-------------------------------------------------------------------
//-------------------------------------------------------------------
//-------------------------------------------------------------------