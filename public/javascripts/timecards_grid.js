$().ready(function(){
    var timecards_grid = jQuery("#timecards_grid").jqGrid({
        url: timecards_url,
        datatype: "json",
        mtype: "POST",
        colNames: ["id", "Company", "Project", "Total Hours", "Status", "Initial Time", "End Time", "", ""],
        datatype: "local",
        width: 935,
        shrinkToFit: false,
        pgtext: false,
        pgbuttons: false,
        pginput: false,
        colModel: [{
            name: 'id',
            index: 'id',
            width: 0,
            hidden: true,
            sortable: false,
            key: true
        }, {
            name: 'company',
            index: 'company',
            align: 'center',
            width: 181,
            sortable: false
        }, {
            name: 'project',
            index: 'project',
            align: 'center',
            width: 180,
            fixed: true,
            sortable: false
        }, {
            name: 'total_hours',
            index: 'total_hours',
            align: 'center',
            width: 90,
            fixed: true,
            sortable: false
        },{
            name: 'status',
            index: 'status',
            align: 'center',
            width: 90,
            fixed: true,
            sortable: false
        }, {
            name: 'initial_time',
            index: 'initial_time',
            width: 115,
            fixed: true,
            align: 'center',
            sortable: false
        }, {
            name: 'end_time',
            index: 'end_time',
            width: 115,
            fixed: true,
            align: 'center',
            sortable: false
        }, {
            name: 'details',
            index: 'details',
            width: 62,
            fixed: true,
            align: 'center',
            sortable: false
        },{
            name: 'edit',
            index: 'edit',
            width: 62,
            fixed: true,
            align: 'center',
            sortable: false
        }],
        height: 'auto',
        emptyrecords: "No projects to display",
        viewrecords: true,
        loadtext: "Loading..."
    });
});
