var projects_grid = "";
var timecards_grid = "";
$(document).ready( function() {
    projects_grid = jQuery("#companies_grid").jqGrid({
        datatype: "json",
        mtype: "POST",
        colNames: ["id", "Name", "Total Projects", "Total Employees", "Registered hours", " "],
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
            name: 'name',
            index: 'name',
            align: 'center',
            width: 302,
            sortable: false
        }, {
            name: 'total_projects',
            index: 'total_projects',
            align: 'center',
            width: 160,
            fixed: true,
            sortable: false
        }, {
            name: 'total_employees',
            index: 'total_employees',
            width: 160,
            fixed: true,
            align: 'center',
            fixed: true,
            sortable: false
        },{
            name: 'total_hours',
            index: 'total_hours',
            align: 'center',
            width: 160,
            fixed: true,
            sortable: false
        }, {
            name: 'details',
            index: 'details',
            width: 128,
            fixed: true,
            align: 'center',
            sortable: false
        }],
        height: 'auto',
        emptyrecords:"No companies to display",
        viewrecords: true,
        loadtext:"Loading..."
    });

    timecards_grid = jQuery("#timecards_grid").jqGrid({
        datatype: "json",
        mtype: "POST",
        colNames: ["id", "Company", "Project", "Registered Hours", "Initial Time", "End Time", " "],
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
            width: 160,
            fixed: true,
            sortable: false
        },{
            name: 'initial_time',
            index: 'initial_time',
            width: 128,
            fixed: true,
            align: 'center',
            sortable: false
        },{
            name: 'end_time',
            index: 'end_time',
            width: 128,
            fixed: true,
            align: 'center',
            sortable: false
        }, {
            name: 'details',
            index: 'details',
            width: 128,
            fixed: true,
            align: 'center',
            sortable: false
        }],
        height: 'auto',
        emptyrecords:"No projects to display",
        viewrecords: true,
        loadtext:"Loading..."

    });
    var lastsel2;
    projects_grid = jQuery("#projects_grid").jqGrid({
        colNames: ["id", "Project", "Registered Hours", "Total Timesheets", " ", " "],
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
            name: 'project',
            index: 'project',
            align: 'center',
            width: 270,
            sortable: false
        }, {
            name: 'registered_hours',
            index: 'registered_hours',
            align: 'center',
            width: 200,
            fixed: true,
            sortable: false
        }, {
            name: 'total_timesheets',
            index: 'total_timesheets',
            align: 'center',
            width: 160,
            fixed: true,
            sortable: false
        },{
            name: 'details',
            index: 'details',
            width: 140,
            fixed: true,
            align: 'center',
            sortable: false
        },{
            name: 'add_timesheet',
            index: 'add_timesheet',
            width: 140,
            fixed: true,
            align: 'center',
            sortable: false
        }],
        height: 'auto',
        emptyrecords:"No timesheets to display",
        viewrecords: true,
        loadtext:"Loading...",
    });
});