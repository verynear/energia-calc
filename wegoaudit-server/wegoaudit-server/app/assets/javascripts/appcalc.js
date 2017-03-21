// Make sure content is as tall as sidebar
//-----------------------------------------
$(function contentMinHeight() {
  $('.js-active-content').css({
    'min-height':($('.js-sidebar-nav').height()+'px')
  });
});


// Click on a table row to select radio option and higlight the row
//-------------------------------------------------------------------
function rowSelector() {
  var $auditTableRow = $('.js-row-selector tr'),
      activeClass = 'active-table-row';

  $auditTableRow.click(function() {
    $(this).siblings().removeClass(activeClass);
    $(this).find('td input[type=radio]').prop('checked', true);
    $(this).addClass(activeClass);
  });
};


// Enable/disable a measure via checkbox
//---------------------------------------
$(function enableMeasure() {
  var $enabler = $('.js-enable-measure'),
      $enableStatus = $('.js-enable-measure-status'),
      $measure = $('.js-measure');

  $enabler.each(function() {
    $(this).on('change', function() {
      if ($(this).is(':checked')) {
        $(this).prev($enableStatus).text('Enabled');
        $(this).closest($measure).removeClass('measure--disabled');
      } else {
        $(this).prev($enableStatus).text('Disabled');
        $(this).closest($measure).addClass('measure--disabled');
      }
    });
  });

  $(window).on('load', function() {
    $enabler.each(function() {
      $(this).change();
    });
  });
});

// Gallery
//---------
$(function enableGalleryImg() {
  var $imageCheckbox = $('.js-enable-image input'),
      $imageThumb = $('.js-gallery');

  $imageCheckbox.each(function() {
    $(this).on('change', function() {
      if ($(this).is(':checked')) {
        $(this).parent().siblings($imageThumb).removeClass('disabled');
      } else {
        $(this).parent().siblings($imageThumb).addClass('disabled');
      }
    });
  });

  $(window).on('load', function() {
    $imageCheckbox.each(function() {
      $(this).change();
    });
  });
});
