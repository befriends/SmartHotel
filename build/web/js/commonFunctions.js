/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

//Function for loading combo values onChange event
/*
 * 
 * @param parentComboId = comboid of parent combo
 * @param childComboId = comboid of child combo
 * @param url = url to call
 * @param submodule = submodule name
 * @returns {}
 * 
 */
function loadComboValues(parentComboId,childComboId,url,submodule){
    var selectedId = document.getElementById(parentComboId).value;
    var parentComboName = document.getElementById(parentComboId).name;
    $.ajax({
        url: url+"?act=4&submodule="+submodule+"&"+parentComboName+"="+selectedId, // act=4 => action 4 is for getting values from DB.
        context: document.body,
        success: function(responseobj){
          var childComponent = document.getElementById(childComboId);
          var jsonObj = JSON.parse(responseobj).data;

          var len = childComponent.length;
          for(var ind=1; ind < len; ind++){
              childComponent.remove(1);
          }

          for(var ind=0; ind < jsonObj.length; ind++){
              var optionEle = document.createElement('option');
              optionEle.value=jsonObj[ind].id;
              optionEle.innerHTML=jsonObj[ind].name;

              childComponent.appendChild(optionEle);
          }
        }
    });
}

function loadComboValues1(parentComboId,childComboId,url,submodule){
    var selectedId = document.getElementById(parentComboId).value;
    var parentComboName = document.getElementById(parentComboId).name;
    $.ajax({
        url: url+"?act=4&submodule="+submodule+"&"+parentComboName+"="+selectedId, // act=4 => action 4 is for getting values from DB.
        context: document.body,
        success: function(responseobj){
          var childComponent = document.getElementById(childComboId);
          var jsonObj = JSON.parse(responseobj).data;

          var len = childComponent.length;
          for(var ind=1; ind < len; ind++){
              childComponent.remove(1);
          }

          for(var ind=0; ind < jsonObj.length; ind++){
              var optionEle = document.createElement('option');
              optionEle.value=jsonObj[ind].id;
              optionEle.innerHTML=jsonObj[ind].name;

              childComponent.appendChild(optionEle);
          }
        }
    });
}

function loadComboValues2(parentComboId,childComboId,url,submodule){
    var selectedId = document.getElementById(parentComboId).value;
    var parentComboName = document.getElementById(parentComboId).name;
    $.ajax({
        url: url+"?act=4&submodule="+submodule+"&"+parentComboName+"="+selectedId, // act=4 => action 4 is for getting values from DB.
        context: document.body,
        success: function(responseobj){
          var childComponent = document.getElementById(childComboId);
          var jsonObj = JSON.parse(responseobj).data;

          var len = childComponent.length;
          for(var ind=1; ind < len; ind++){
              childComponent.remove(1);
          }

          for(var ind=0; ind < jsonObj.length; ind++){
              var optionEle = document.createElement('option');
              optionEle.value=jsonObj[ind].id;
              optionEle.innerHTML=jsonObj[ind].name;

              childComponent.appendChild(optionEle);
          }
        }
    });
}