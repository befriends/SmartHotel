
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script src="js/jquery.js"></script>
        <script type="text/javascript">
            $('#remote_input2').autocomplete({source:[{
 data:[
  {id:1, title:"alabama"},
  {id:2, title:"alaska"},
  {id:3, title:"georgia"},
  {id:4, title:"texas"},
  {id:6, title:"california"}
 ],
 getTitle:function(item){
  return item['title']
 },
 getValue:function(item){
  return item['title']
 },	
}]}).on('selected.xdsoft',function(e,datum){
 alert(datum.id);
 alert(datum.title);
});
        </script>
    </head>
    <body>
        <h1>Hello World!</h1>
        DropDown : <input type="text" id="remote_input2" autocomplete="on" />
    </body>
</html>
