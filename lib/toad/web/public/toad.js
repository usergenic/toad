$(function(){

  /* click on tag in the table cell to filter by that tag */
  $("table.tagged td .label").live("click", function(){

    var label = $(this);
    var tagid = label.attr("data-tag");
 
    // copy label into the tagged list in column header
    label
      .parents("table")
      .first()
      .find("th .tagged")
      .append(label.clone());

    // find all table rows with the tag and hide them
    label
      .parents("tbody")
      .first()
      .find("tr")
      .not(function(){
        return $(this).find("td .label[data-tag='"+tagid+"']").size() > 0;
      })
      .hide();

  });

  /* click on the tag in the header cell to remove the filter */
  $("table.tagged th .label").live("click", function(){

    var label = $(this);
    var tagid = label.attr("data-tag");
    var table = label.parents("table").first();

    // remove the filtered tag from column header.
    label.remove();

    // find all tags still to be filtered on.
    var filterTagids = table
      .find('th .tagged .label')
      .map(function(){
        return $(this).attr("data-tag");
      });


    // unhide rows containing this tag and no other tags in the filter list
    table                                         
      .find("tbody tr")
      .filter(function(){
        var stayFiltered = false;
        $(this).find(".label").each(function(){
          if($.inArray($(this).attr("data-tag"), filterTagids)+1)
            stayFiltered = true;
        });
        return !stayFiltered;
      })
      .show();
  });

});
