/* 
 *
 */

function showeditrecord(cnt) {
    document.getElementById('recordid' + cnt).style.display = "none";
    document.getElementById('editrecordid' + cnt).style.display = "";
}

function updaterecord(cnt) { //fro Saving edited row data
    var submodule = $('#submodule').text();
    var url = "UserController";
    var editTrEle = $('#editrecordid' + cnt);
    var categoryid = null;
    var categoryName = null;
   
    var employeeid = null;
    var employeeName = null;
    var address = null;
    var mobile = null;
    var gender = null;
    var dob = null;
    var hiredate = null;
    var params = "";

    if (submodule === "category") {
        categoryid = editTrEle.find("label[id='categoryid']").text();
        categoryName = editTrEle.find("input[name='categoryname']")[0].value;
        params = '{ "data" : [' +
                '{ "categoryid":"' + categoryid + '" , "categoryname":"' + categoryName + '" }]}';
        var jsonObj = JSON.parse(params);

        saveRecord(url, submodule, "editrecordid" + cnt, "recordid" + cnt, jsonObj);

    } else if (submodule === "employee") {

        employeeid = editTrEle.find("label[id='employeeid']").text();
        employeename = editTrEle.find("input[name='employeename']")[0].value;
        address = editTrEle.find("input[name='address']")[0].value;
        mobile = editTrEle.find("input[name='mobile']")[0].value;
        gender = editTrEle.find("input[name='gender']")[0].value;
        dob = editTrEle.find("input[name='dob']")[0].value;
        hiredate = editTrEle.find("input[name='hiredate']")[0].value;

        params = '{ "data" : [' +
                '{ "employeeid":"' + employeeid + '" , "employeename":"' + employeeName + '","address":"' + address + '" , "mobile":"' + mobile + '" , "gender":"' + gender + '", "dob":"' + dob + '", "hiredate":"' + hiredate + '"}]}';
        var jsonObj = JSON.parse(params);
        saveRecord(url, submodule, "editrecordid" + cnt, "recordid" + cnt, jsonObj);
    }
        else if (submodule === "employee11") {
        url = "UserController";
        var employeeid = null;
        var employeename = null;
        var designation = null;
        var mobile = null;
        var gender = null;
        var dob = null;
        var hiredate = null;

        employeeid = editTrEle.find("label[id='employeeid']").text();
        employeename = editTrEle.find("input[name='employeename']")[0].value;
        designation = editTrEle.find("input[name='designation']")[0].value;
        mobile = editTrEle.find("input[name='mobile']")[0].value;
        gender = editTrEle.find("input[name='gender']")[0].value;
        dob = editTrEle.find("input[name='dob']")[0].value;
        hiredate = editTrEle.find("input[name='hiredate']")[0].value;
        params = '{ "data" : [' +
                '{ "employeeid":"'+employeeid+'","employeename":"'+employeename+'", "designation":"'+designation+'","mobile":"'+mobile+'","gender":"'+gender+'","dob":"'+dob+'","hiredate":"'+hiredate+'" }]}';
        var jsonObj = JSON.parse(params);
        saveRecord(url, submodule, "editrecordid" + cnt, "recordid" + cnt, jsonObj);
    }
}

function saveRecordData(cnt) { //for Saving new row data
    document.getElementById('editrecordid' + cnt).style.display = "none";
    document.getElementById('recordid' + cnt).style.display = "";

    var innerhtml = $('#editrecordid' + cnt)[0].innerHTML;
    innerhtml = innerhtml.replace("saveRecordData", "updaterecord");
    innerhtml = innerhtml.replace("removerow", "cancel");
    innerhtml = innerhtml.replace("Remove", "Cancel");
    $('#editrecordid' + cnt)[0].innerHTML = innerhtml;
}

function cancel(cnt) {
    document.getElementById('editrecordid' + cnt).style.display = "none";
    document.getElementById('recordid' + cnt).style.display = "";
}

function deleterecord(cnt) {
    var submodule = $('#submodule').text();
    var url = "UserController";
    var trEle = $('#recordid' + cnt);

    if (submodule === "category") {
        var categoryid = trEle.find('label[id="categoryid"]').text();
        deleteRecord(url, submodule, "editrecordid" + cnt, "recordid" + cnt, categoryid);
    }  else if (submodule === "employee") {
        var employeeid = trEle.find('label[id="employeeid"]').text();
        deleteRecord(url, submodule, "editrecordid" + cnt, "recordid" + cnt, employeeid);
    }

}

function addrow() {
    var countEle = $('#recordcount');
    var count = parseInt(countEle.text());
    countEle.text(count + 1);

    var trEle1 = document.createElement('tr');
    trEle1.id = "editrecordid" + count;
    trEle1.classList.add('info');

    var innerhtml = "<form name=\"editrecords\">"
            + "</form><td><label>" + count + "</label></td><td><input value=\"\" type=\"text\"></td>"
            + "<td><input value=\"\" type=\"email\"></td><td><select name=\"age\">"
            + "<option>20</option><option>23</option><option>25</option><option>27</option><option>30</option>"
            + "</select></td><td><p class=\"btn btn-info\" onClick=\"saveRecordData(" + count + ")\"><span class=\"glyphicon glyphicon-save\"></span>&nbsp;Save</p>"
            + "&nbsp;&nbsp;|&nbsp;&nbsp;<p class=\"btn btn-default\" onClick=\"removerow(" + count + ")\"><span class=\"glyphicon glyphicon-remove\"></span>&nbsp;Remove</p>";
    trEle1.innerHTML = innerhtml;
    $("#tbl").append(trEle1);

    var trEle2 = document.createElement('tr');
    trEle2.id = "recordid" + count;
    trEle2.classList.add('success');
    trEle2.style.display = "none";
    var innerhtml = "<td><label>" + count + "</label></td><td><label></label></td>"
            + "<td><label></label></td><td><label></label></td><td>"
            + "<p class=\"btn btn-success\" onClick=\"showeditrecord(" + count + ")\"><span class=\"glyphicon glyphicon-pencil\"></span>&nbsp;Edit</p>"
            + "&nbsp;&nbsp;|&nbsp;&nbsp;<p class=\"btn btn-danger\"><span class=\"glyphicon glyphicon-trash\"></span>&nbsp;Delete</p></td>";
    trEle2.innerHTML = innerhtml;
    $("#tbl").append(trEle2);
}

function removerow(cnt) {
//    document.getElementById('editrecordid'+cnt).style.display="none";
//    document.getElementById('recordid'+cnt).style.display="";
    document.getElementById('editrecordid' + cnt).outerHTML = "";
    document.getElementById('recordid' + cnt).oterHTML = "";
    var countEle = $('#recordcount');
    var count = parseInt(countEle.text());
    countEle.text(count - 1);
}

function saveRecord(url, submodule, editablerowid, displayrowid, jsonObj) {
    $.ajax({
        url: url + "?act=2&submodule=" + submodule + "&extraParams=" + JSON.stringify(jsonObj), // act=2 => action 2 is for save record to DB.
        context: document.body,
        success: function(responseObj) {
            var responseJsonObj = JSON.parse(responseObj);
            var isSuccess = responseJsonObj.success;
            if (isSuccess) {
                var editTrEle = $('#' + editablerowid);
                var recordTrEle = $('#' + displayrowid);
                if (submodule === "category") {
                    var categoryName = jsonObj.data[0].categoryname;
                    recordTrEle.find("label[name='categoryname']").text(categoryName);
                    editTrEle.find("input[name='categoryname']").val(categoryName);
                
                } else if (submodule === "employee") {
                    var employeename = jsonObj.data[0].employeename;
                    var designation = jsonObj.data[0].designation;
                    var mobile = jsonObj.data[0].mobile;
                    var gender = jsonObj.data[0].gender;
                    var dob = jsonObj.data[0].dob;
                    var hiredate = jsonObj.data[0].hiredate;
                    recordTrEle.find("label[name='employeename']").text(employeename);
                    editTrEle.find("input[name='employeename']").val(employeename);
                    recordTrEle.find("label[name='designation']").text(designation);
                    editTrEle.find("input[name='designation']").val(designation);
                    recordTrEle.find("label[name='mobile']").text(mobile);
                    editTrEle.find("input[name='mobile']").val(mobile);
                    recordTrEle.find("label[name='gender']").text(gender);
                    editTrEle.find("input[name='gender']").val(gender);
                    recordTrEle.find("label[name='dob']").text(dob);
                    editTrEle.find("input[name='dob']").val(dob);
                    recordTrEle.find("label[name='hiredate']").text(hiredate);
                    editTrEle.find("input[name='hiredate']").val(hiredate);

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
