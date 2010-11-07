( function($) {
    var alog = window.console ? console.log : alert;

    $.fn.mini_timepicker = function() {

      var defaults = {

      };

      var methods =  {
        init_mini_timepicker: function () {
          if ($(document).data("loaded_time_hooks")) {
            return;
          } // we use jQuery.live() we don't need to load twice!
          $(".mtp_hrs").live('keyup', function(ev) {
            var len = $(this).val().length;
            var tabbed_in = ev.keyCode == '9' || ev.keyCode=='16' || false;
            if(len==2 && !tabbed_in) {
              // if typed two digits focus on next time
              $(this).change(); // focusing on next element causes js to skip change() bind, we call it manualy
              $(this).next().next().select();
            }
            if( parseInt( $(this).val() ) >= 23 ) {
              $(this).val("23").change();
            }
          });

          $(".mtp_hrs,.mtp_mins").live('click', function() {
            $(this).select();
          });

          $(".mtp_mins,.mtp_hrs").live('change', function() {

            if (  isNaN($(this).val())  ) {
              // if we have chars and one of them is not a number, reset to 00
              $(this).val("00");
            } else if ( $(this).val().length == 1 && !isNaN($(this).val()) ) {
              $(this).val("0"+$(this).val());
            }

            // after change we update the hidden
            var hidden = $(this).parent().prev();
            var hrs = hidden.next().children('.mtp_hrs');
            var mins = hidden.next().children('.mtp_mins');
            hidden.val( hrs.val() + ":" + mins.val() );
          })

          $(".mtp_mins,.mtp_hrs").live('keyup', function (ev) {
            var inp = $(this);
            var max=0;
            if ( inp.hasClass('mtp_mins') ) {
              max=59;
            } else {
              max=23;
            }

            if( parseInt( inp.val() ) > max ) {
              $(this).val(max);
            }

            if (ev.keyCode=='38') { // up was pressed

              if( isNaN(inp.val() )|| inp.val() >= max ) {
                inp.val("00"); // if we have non num char or we are at 59 in textbox, reset it
              } else {
                inp.val(parseInt(inp.val(),10) + 1); // if we're at zero go back to 59 mins.
                inp.change().select();
              }
              inp.change().select();
            } else if (ev.keyCode=='40') { //down was pressed
              if( isNaN(inp.val() ) ) {
                inp.val("00");
              } else if (parseInt(inp.val(),10)==0) {
                inp.val(max);
              } else {
                inp.val(parseInt(inp.val(),10) - 1);
                inp.change();
              }
              inp.change().select();
            } else if (ev.keyCode=='39' && inp.hasClass('mtp_hrs')) { // right was pressed on hrs inp
              inp.next().select();
            } else if (ev.keyCode=='37' && inp.hasClass('mtp_mins')) { // left was pressed on mins inp
              inp.prev().prev().select();
            }

          });
          
          var orig = this;
          var old_value = orig.attr("value");
          var old_values = old_value.split(':');
          var length = old_values.length;
          // check that the value is a valid time
          if(length > 1){
            for (var i = 0;i<length;i=i+1)
            {
              var val = old_values[i];
              if (isNaN(val)){
                val = "00";
              } else if ( $(this).val().length == 1 && !isNaN($(this).val()) ) {
                val = ("0"+val);
              }
              var max;
              if(i == 0){
                max=23;
              }else{
                max=59;
              }
              if(parseInt(val) > max ) {
                val = max;
              }
              old_values[i] = val;
            }
            original_id = orig.id;
            $("#"+original_id +"_tp_dup > .mtp_hrs").val(old_values[0]);
            $("#"+original_id +"_tp_dup > .mtp_mins").val(old_values[1]);
          }else{
            
          }
          
          $(document).data("loaded_time_hooks",true);

        },

        draw_dupe_inputs: function(orig) {
          var new_id = orig.attr("id") + "_tp_dup";
          orig.after("<div id='"+new_id+"' dir='ltr' ></div>");
          var copy=$("#"+new_id);

          //copy.height( orig.height() ).width( orig.width() );
          var attrs_to_cpy = ["border-top-width","border-top-color","border-top-style",
          "border-bottom-width","border-bottom-color","border-bottom-style",
          "border-right-width","border-right-color","border-right-style",
          "border-left-width","border-left-color","border-left-style",
          "height","width","font-size","text-align","display"];

          // copy important css data from the original to the dupe container div
          $.each(attrs_to_cpy, function(index,val) {
            copy.css(val,orig.css(val));
          });
          orig.addClass("base_input").hide();
          copy.append('<input type="text" class="mtp_hrs" maxlength="2" value="00"><span class="seperator_colon">:</span><input type="text" class="mtp_mins" maxlength="2" value="00">');
          // create the dupe's internal inputs
          var seperator_colon_width = $("#" + new_id + " .seperator_colon").width();
          var outside_div_border = parseInt($("#"+new_id).css("border-top-width").split("px")[0])+parseInt($("#"+new_id).css("border-bottom-width").split("px")[0]);
          $("#"+new_id+" .mtp_mins, #"+new_id+" .mtp_hrs").css("border","0px").height(orig.height()-outside_div_border).width((orig.width()/2)-seperator_colon_width).css("font-size",orig.css("font-size")).css("text-align","center");
        }

      };

      this.each( function() {

        var $this = $(this);

        if (! ($this.is('input') && $this.attr("type")=='text' ) ) {
          return ;
        }

        if (! $this.hasClass('base_input') ) {
          methods.draw_dupe_inputs($this);
        }

      });

      methods.init_mini_timepicker();

      return this;

    }

  })(jQuery);