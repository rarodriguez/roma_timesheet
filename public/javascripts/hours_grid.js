var hours_grid = ""; 
$(document).ready( function() {
  var lastsel2;
  hours_grid = jQuery("#hours_grid").jqGrid({
    colNames: ["id", "Initial Time","End Time","Date","Description", "Total Hours",""],
    datatype: "local",
    width: 935,
    shrinkToFit: false,
    pgtext: false,
    pgbuttons: false,
    pginput: false,
    colModel: [
      {name: 'id',index: 'id',width: 0,hidden: true,sortable: false, key: true},
      {name: 'initial_time',index: 'initial_time',align: 'center',width: 100,editable:true,resizable:false,editrules:{required:true,time:true},editoptions:{size:10},fixed: true,sortable: false},
      {name: 'end_time', index: 'end_time', align: 'center', width: 100, editable:true,resizable:false, editrules:{required:true,time:true,custom:true,custom_func:end_time_check},editoptions:{size:10}, fixed: true, sortable: false},
      {name: 'date', index: 'date',datefmt:'mm-dd-yyyy', align: 'center', editable:true, resizable:false, width: 100, sortable: false,editrules:{required:true,date:true}},
      {name: 'description',index: 'description',align: 'center',editable: true,resizable:false,edittype:"textarea", editrules:{required:true},editoptions:{rows:"3",cols:"25"},width: 475,fixed: true,sortable: false },
      {name: 'total_hours',index: 'total_hours',align: 'center',width: 100,editable:false,resizable:false,fixed: true,sortable: false},
      {name: 'delete',index: 'delete', align: 'center',width: 30,editable:false,resizable:false,fixed: true,sortable: false}
    ],
    url: listing_grid,
    datatype: "json",
    mtype: "POST",
    height: 'auto',
    emptyrecords:"No timesheets to display",
    viewrecords: true,
    loadtext:"Loading...",
    editurl: edit_url,
    onSelectRow: function(id) {
      if(id && id!==lastsel2) {
        jQuery('#hours_grid').jqGrid('editGridRow',id,
        {
          closeAfterEdit:true,
          afterShowForm:pickdates,
          afterSubmit:after_submit_handler
        }
        );
        lastsel2=id;
      }
    },
    gridComplete: function(){
      var ids = jQuery("#hours_grid").jqGrid('getDataIDs');
      for(var i=0;i < ids.length;i++) {
        var cl = ids[i];
        ce = '<input type="button" class="delete_btn" title="Delete this hour" id="btn_'+cl+'" style="background-image:url(/images/trash.png);display:block;height:16px;width:16px;margin:0 auto;border:none;background-color:none;>&nbsp;&nbsp;</input>"'
        jQuery("#hours_grid").jqGrid('setRowData',ids[i],{delete:ce});
      }
      
      $('.delete_btn').click(function(){
        $(this).fastConfirm({
          position:'left',
          questionText: "Are you sure you want <br />to delete the selected hour?",
          onProceed:function(trigger){
            delete_hour(trigger.id);
          }
        });
      });
    }
  });
  $('#add_hours').click( function() {
    jQuery("#hours_grid").jqGrid('editGridRow', "new",
    {
      closeAfterEdit:true,
      closeAfterAdd:true,
      afterShowForm:pickdates,
      afterSubmit:after_submit_handler
    }
    );
  });

  function pickdates(id) {
    $("input[id=date]").attr('editable',false);
    $("input[id=date]").datepicker({dateFormat:"mm-dd-yy"});
  }

  function end_time_check(value, colname) {
    var initial_time = $("input[id=initial_time]").val();
    if (value <= initial_time) {
      return [false,"End time should be greater than initial time"];
    } else {
      return [true,""];
    }
  }

  function after_submit_handler(response, postdata, formid) {
    var message = "";
    var is_valid = false;
    var new_id = 0;
    try {
      if(response != null) {
        response = jQuery.parseJSON(response.responseText);
        if(response.redirect == true || response.redirect == 'true') {
          window.location.replace(response.url);
        } else {
          is_valid = response.success;
          if(is_valid == true || is_valid == 'true') {
            hours_grid.trigger('reloadGrid');
          } else {
            message = response.message;
          }
        }
      } else {
        window.location.reload();
      }
    } catch (exc) {
      message = "We had an unexpected error, please try again."
    }
    return [is_valid,message,new_id]
  }
  
  function delete_hour(id){
    id = id.split('_');
    if(id.length == 2){
      id = id[1];
      var dataString = 'authenticity_token=' + $('meta[name=csrf-token]').attr('content') + '&_method=delete';
      $.ajax({
        type: "POST",
        url: delete_url+id,
        data: dataString,
        dataType: 'json',
        success: function(data){
          if (data != null) {
            if(data.redirect == true || data.redirect == 'true') {
              window.location.replace(data.url);
            }else{
              if (data.success) {
                hours_grid.trigger('reloadGrid');
              }
              else {
                alert("We had a problem while deleting the hour registry, please try again.");
              }
            }
          }else{
            window.location.reload();
          }
        },
        error: function(request, error){
          alert("We had a problem while deleting the hour registry, please try again.");
        }
      });
  }
}

});