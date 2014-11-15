<html>
<head>
  <title>{{title or 'No title'}}</title>
  <style type="text/css">
    body {
      background-color: #555;
      color: #bbb;
      font-family: arial;
      margin: 0 0 0 0;
    }
    a {
      color: #ccc;
      text-decoration: none;
      font-weight: bold;
    }
    .entry {
      width: 200px;
      height: 200px;
      margin: 5px;
      float: left;
      overflow: hidden;
      background-color: #333;
    }
    .categories {
      background-color: #888;
      position: absolute;
      padding-left: 36px;
      top: 0px;
      z-index: 90;
      height: 26px;
      padding-top: 6px;
      padding-right: 12px;
    }
    .label {
      background-color: #888;
      height: 18px;
    }
    .catD {
      border-bottom: 20px solid red;
    }
    .catN {
      background-color: #8a2;
    }
    .catA {
      background-color: #28c;
    }
    .catX {
      border-left: 16px solid #c82;
    }
    #menu {
      color: #999;
      height: 32px;
      width: 32px;
      position: fixed;
      left: 0px;
      top: 0px;
      z-index: 100;
    }
    .button {
      width: 32px;
      height: 32px;
    }
    .top {
      position: absolute;
      top: 40px;
      left: 5px;
    }
    .title {
      font-weight: bold;
      font-size: 30px;
      position: fixed;
      top: 0px;
      left: 0px;
      padding-left: 5px;
      width: 100%;
      background-color: rgba(50, 50, 50, 0.50);
    }
    .viewtitle {
      font-size: 30px;
      position: fixed;
      top: 0px;
      left: 0px;
      padding-left: 5px;
    }
    #grid {
        margin-top: 100px;
    }
    .menu_thumb {
        position: fixed;
        top: 40px;
        left: 10px;
    }
    .menu {
        position: absolute;
        top: 42px;
        left: 230px;
    }
    .form {
        position: absolute;
        left: 10px;
        top: 130px;
    }
    .created_collection {
        position: absolute;
        left: 10px;
        top: 70px;
        padding: 10px;
        background-color: #385;
        color: white:
        font-weight: bold;
    }
  </style>
  <script src="/js/jquery-1.11.0.min.js"></script>
</head>
<body>
  {{!base}}
  <script language="javascript">
     $(document).keydown(function(e){
        var keyCode = e.keyCode || e.which;
        if (String.fromCharCode(keyCode).toLowerCase() == 's' && e.ctrlKey) { // Ctrl-S
            e.preventDefault();
            $.ajax({
                url: "/save",
                type: 'PUT',
                success: function(result) {
                  alert("Saved");
                }
            });
        }
     });
  </script>
</body>
</html>
