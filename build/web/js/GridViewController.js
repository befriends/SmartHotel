/* 
 *
 */

function showeditrecord(cnt){
    document.getElementById('recordid'+cnt).style.display="none";
    document.getElementById('editrecordid'+cnt).style.display="";
}

function updaterecord(cnt){ //fro Saving edited row data
    var submodule = $('#submodule').text();
    var url = "MenuItemController";
    var editTrEle = $('#editrecordid'+cnt);
    var categoryid = null;
    var categoryName = null;
    var tableid = null;
    var tableName = null;
    var subcategoryid = null;
    var subCategoryname = null;
    var menuitemid = null;
    var menuitemname = null;
    var messgaetype= null;
    var messageid=null;
    var isactive=null;
    var rate = null;
    var params = "";
    
    if(submodule === "category"){
        categoryid = editTrEle.find("label[id='categoryid']").text();
        categoryName = editTrEle.find("input[name='categoryname']")[0].value;
        params = '{ "data" : [' +
                '{ "categoryid":"'+categoryid+'" , "categoryname":"'+categoryName+'" }]}';
        var jsonObj = JSON.parse(params);
        
        saveRecord(url,submodule,"editrecordid"+cnt,"recordid"+cnt,jsonObj);
        
    } else if(submodule === "subcategory"){
        //categoryid = editTrEle.find("label[id='categoryid']").text();
        //categoryName = editTrEle.find("input[name='subcategoryname']")[0].value;
        subcategoryid = editTrEle.find("label[id='subcategoryid']").text();
        subCategoryname = editTrEle.find("input[name='subcategoryname']")[0].value;
        params = '{ "data" : [' +
                '{ "subcategoryid":"'+subcategoryid+'" , "subcategoryname":"'+subCategoryname+'" }]}';
        var jsonObj = JSON.parse(params);
        saveRecord(url,submodule,"editrecordid"+cnt,"recordid"+cnt,jsonObj);
        
    } else if(submodule === "menuitem"){
        //categoryName = editTrEle.find("input[name='menuitemname']")[0].value;
        menuitemid = editTrEle.find("label[id='menuitemid']").text();
        menuitemname = editTrEle.find("input[name='menuitemname']")[0].value;
        rate = editTrEle.find("input[name='rate']")[0].value;
        params = '{ "data" : [' +
                '{ "menuitemid":"'+menuitemid+'" , "menuitemname":"'+menuitemname+'","rate":"'+rate+'"  }]}';
        var jsonObj = JSON.parse(params);
        saveRecord(url,submodule,"editrecordid"+cnt,"recordid"+cnt,jsonObj);
    }
    else if(submodule === "table"){
        tableid = editTrEle.find("label[id='tableid']").text();
        tableName = editTrEle.find("input[name='tablename']")[0].value;
        params = '{ "data" : [' +
                '{ "tableid":"'+tableid+'" , "tablename":"'+categoryName+'" }]}';
        var jsonObj = JSON.parse(params);
        
        saveRecord(url,submodule,"editrecordid"+cnt,"recordid"+cnt,jsonObj);
    }
    else if(submodule === "employee"){
        url = "UserController";
        var employeeid = null;
        var employeename = null;
        var designation = null;
        var address = null;
        var mobile = null;
        var gender = null;
        var dob = null;
        var hiredate = null;

        employeeid = editTrEle.find("label[id='employeeid']").text();
        employeename = editTrEle.find("input[name='employeename']")[0].value;
        designation = editTrEle.find("input[name='designation']")[0].value;
        address = editTrEle.find("input[name='address']")[0].value;
        mobile = editTrEle.find("input[name='mobile']")[0].value;
        gender = editTrEle.find("input[name='gender']")[0].value;
        dob = editTrEle.find("input[name='dob']")[0].value;
        hiredate = editTrEle.find("input[name='hiredate']")[0].value;
        params = '{ "data" : [' +
                '{ "employeeid":"'+employeeid+'" , "employeename":"'+employeename+'", "designation":"'+designation+'", "address":"'+address+'", "mobile":"'+mobile+'", "gender":"'+gender+'", "dob":"'+dob+'", "hiredate":"'+hiredate+'" }]}';
        var jsonObj = JSON.parse(params);
        
        saveRecord(url,submodule,"editrecordid"+cnt,"recordid"+cnt,jsonObj);
    }
    else if(submodule === "message"){
        messageid = editTrEle.find("label[id='messageid']").text();
        isactive = editTrEle.find("input[name='isactive']")[0].value;
        params = '{ "data" : [' +
                '{ "messageid":"'+messageid+'" , "isactive":"'+isactive+'" }]}';
        var jsonObj = JSON.parse(params);
        
        saveRecord(url,submodule,"editrecordid"+cnt,"recordid"+cnt,jsonObj);
    }
}

function saveRecordData(cnt){ //for Saving new row data
    document.getElementById('editrecordid'+cnt).style.display="none";
    document.getElementById('recordid'+cnt).style.display="";
    
    var innerhtml = $('#editrecordid'+cnt)[0].innerHTML;
    innerhtml = innerhtml.replace("saveRecordData","updaterecord");
    innerhtml = innerhtml.replace("removerow","cancel");
    innerhtml = innerhtml.replace("Remove","Cancel");
    $('#editrecordid'+cnt)[0].innerHTML = innerhtml;
}

function cancel(cnt){
    document.getElementById('editrecordid'+cnt).style.display="none";
    document.getElementById('recordid'+cnt).style.display="";
}

function deleterecord(cnt){
    var submodule = $('#submodule').text();
    var url = "MenuItemController";
    var trEle = $('#recordid'+cnt);
    
    if(submodule === "category"){
        var categoryid = trEle.find('label[id="categoryid"]').text();
        deleteRecord(url,submodule,"editrecordid"+cnt,"recordid"+cnt,categoryid);
    } else if(submodule === "subcategory"){
        var subcategoryid = trEle.find('label[id="subcategoryid"]').text();
        deleteRecord(url,submodule,"editrecordid"+cnt,"recordid"+cnt,subcategoryid);
    } else if(submodule === "menuitem"){
        var menuitemid = trEle.find('label[id="menuitemid"]').text();
        deleteRecord(url,submodule,"editrecordid"+cnt,"recordid"+cnt,menuitemid);
    
    } else if(submodule === "employee"){
        var url = "UserController"
        var employeeid = trEle.find('label[id="employeeid"]').text();
        deleteRecord(url,submodule,"editrecordid"+cnt,"recordid"+cnt,employeeid);
    }else if(submodule === "message"){
        var messageid = trEle.find('label[id="messageid"]').text();
        deleteRecord(url,submodule,"editrecordid"+cnt,"recordid"+cnt,messageid);
    }
    
}

function addrow(){
    var countEle = $('#recordcount');
    var count = parseInt(countEle.text());
    countEle.text(count+1);
    
    var trEle1 = document.createElement('tr');
    trEle1.id="editrecordid"+count;
    trEle1.classList.add('info');

    var innerhtml = "<form name=\"editrecords\">"
            +"</form><td><label>"+count+"</label></td><td><input value=\"\" type=\"text\"></td>"
            +"<td><input value=\"\" type=\"email\"></td><td><select name=\"age\">"
	    +"<option>20</option><option>23</option><option>25</option><option>27</option><option>30</option>"
	    +"</select></td><td><p class=\"btn btn-info\" onClick=\"saveRecordData("+count+")\"><span class=\"glyphicon glyphicon-save\"></span>&nbsp;Save</p>"
            +"&nbsp;&nbsp;|&nbsp;&nbsp;<p class=\"btn btn-default\" onClick=\"removerow("+count+")\"><span class=\"glyphicon glyphicon-remove\"></span>&nbsp;Remove</p>";
    trEle1.innerHTML = innerhtml;
    $("#tbl").append(trEle1);
    
    var trEle2 = document.createElement('tr');
    trEle2.id="recordid"+count;
    trEle2.classList.add('success');
    trEle2.style.display="none";
    var innerhtml = "<td><label>"+count+"</label></td><td><label></label></td>"
		+"<td><label></label></td><td><label></label></td><td>"
                +"<p class=\"btn btn-success\" onClick=\"showeditrecord("+count+")\"><span class=\"glyphicon glyphicon-pencil\"></span>&nbsp;Edit</p>"
                +"&nbsp;&nbsp;|&nbsp;&nbsp;<p class=\"btn btn-danger\"><span class=\"glyphicon glyphicon-trash\"></span>&nbsp;Delete</p></td>";
    trEle2.innerHTML = innerhtml;
    $("#tbl").append(trEle2);
}

function removerow(cnt){
//    document.getElementById('editrecordid'+cnt).style.display="none";
//    document.getElementById('recordid'+cnt).style.display="";
    document.getElementById('editrecordid'+cnt).outerHTML="";
    document.getElementById('recordid'+cnt).oterHTML="";
    var countEle = $('#recordcount');
    var count = parseInt(countEle.text());
    countEle.text(count-1);
}

function saveRecord(url, submodule, editablerowid, displayrowid, jsonObj) {
    $.ajax({
        url: url + "?act=2&submodule=" + submodule + "&extraParams=" + JSON.stringify(jsonObj), // act=2 => action 2 is for save record to DB.
        context: document.body,
        success: function(responseObj) {
            var responseJsonObj = JSON.parse(responseObj);
            var isSuccess = responseJsonObj.success;
            if (isSuccess) {
                var editTrEle = $('#'+editablerowid);
                var recordTrEle = $('#'+displayrowid);
                if (submodule === "category") {
                    var categoryName = jsonObj.data[0].categoryname;
                    recordTrEle.find("label[name='categoryname']").text(categoryName);
                    editTrEle.find("input[name='categoryname']").val(categoryName);
                } else if (submodule === "subcategory") {
                     var subcategoryName = jsonObj.data[0].subcategoryname;
                    recordTrEle.find("label[name='subcategoryname']").text(subcategoryName);
                    editTrEle.find("input[name='subcategoryname']").val(subcategoryName);
                    
                } else if (submodule === "menuitem") {
                    var menuitemname = jsonObj.data[0].menuitemname;
                    recordTrEle.find("label[name='menuitemname']").text(menuitemname);
                    editTrEle.find("input[name='menuitemname']").val(menuitemname);
                    var rate = jsonObj.data[0].rate;
                    recordTrEle.find("label[name='rate']").text(rate);
                    editTrEle.find("input[name='rate']").val(rate);

                }else if (submodule === "table") {
                    var tablename = jsonObj.data[0].tablename;
                    recordTrEle.find("label[name='tablename']").text(tablename);
                    editTrEle.find("input[name='tablename']").val(tablename);
                }else if (submodule === "employee") {
                    url = "UserController";
                    var employeename = jsonObj.data[0].employeename;
                    var designation = jsonObj.data[0].designation;
                    var address = jsonObj.data[0].address;
                    var mobile = jsonObj.data[0].mobile;
                    var gender = jsonObj.data[0].gender;
                    var dob = jsonObj.data[0].dob;
                    var hiredate = jsonObj.data[0].hiredate;
                    recordTrEle.find("label[name='employeename']").text(employeename);
                    editTrEle.find("input[name='employeename']").val(employeename);
                    recordTrEle.find("label[name='designation']").text(designation);
                    editTrEle.find("input[name='designation']").val(designation);
                    recordTrEle.find("label[name='address']").text(address);
                    editTrEle.find("input[name='address']").val(address);
                    recordTrEle.find("label[name='mobile']").text(mobile);
                    editTrEle.find("input[name='mobile']").val(mobile);
                    recordTrEle.find("label[name='gender']").text(gender);
                    editTrEle.find("input[name='gender']").val(gender);
                    recordTrEle.find("label[name='dob']").text(dob);
                    editTrEle.find("input[name='dob']").val(dob);
                    recordTrEle.find("label[name='hiredate']").text(hiredate);
                    editTrEle.find("input[name='hiredate']").val(hiredate);
                    
                }else if (submodule === "message") {
                    var isactive = jsonObj.data[0].isactive;
                    recordTrEle.find("label[name='isactive']").text(isactive);
                    editTrEle.find("input[name='isactive']").val(isactive);
                }
                
                document.getElementById(editablerowid).style.display = "none";
                document.getElementById(displayrowid).style.display = "";
                alert('Updated Successfuly');
            }
        }
    });
}

function deleteRecord(url, submodule, editablerowid, displayrowid, recId) {
    $.ajax({
        url: url + "?act=3&submodule=" + submodule + "&id=" + recId, // act=3 => action 3 is for delete record from DB.
        context: document.body,
        success: function(responseObj) {
            var responseJsonObj = JSON.parse(responseObj);
            var isSuccess = responseJsonObj.success;
            if (isSuccess) {
                document.getElementById(editablerowid).remove();
                document.getElementById(displayrowid).remove();
                
                alert('Deleted Successfuly');
            }
        }
    });
}
