// Make notification appear after clicking delete icon
//-----------------------------------------------------
$(function deleteStructure() {
  $('.js-trash').click(function(e) {
    $(this).siblings('.js-delete-query').addClass('in');
    e.preventDefault();
  });
  $('.js-delete-query-no').click(function(e) {
    $(this).closest('.js-delete-query').removeClass('in');
    e.preventDefault();
  });
});


// Confirm deletion and remove the row
//-------------------------------------
$(function removeStructure() {
  $('.js-delete-query-yes').click(function() {
    $(this).closest('.js-structure-row')
    .addClass('deleting')
    .fadeOut(600, function() { $(this).remove(); })
  });
});

$(function cloneAudit() {
  $('.js-clone-audit').on('click', function (e) {
    var $target = $(this),
        $modal = $($target.attr('href')),
        $sourceId = $modal.find('.js-source-audit-id'),
        $auditType = $modal.find('.js-audit-type');

    $sourceId.val($target.data('source-audit-id'));
    $auditType.val($target.data('audit-type'));
    e.preventDefault();
  });
});

$(function cloneStructure() {
  $('.js-clone-structure').on('click', function (e) {
    var $target = $(this),
        $modal = $($target.attr('href')),
        $sourceId = $modal.find('.js-source-structure-id');

    $sourceId.val($target.data('source-structure-id'));
    e.preventDefault();
  });
});

$(function linkStructure() {
  $('.js-link-structure').on('click', function(e) {
    var $target = $(this),
        $modal = $($target.attr('href')),
        $form = $modal.find('.js-submit-link');

    $form.attr('action', $target.data('structure-path'));
    e.preventDefault();
  });
});

// Open/close modal controls
//---------------------------
$(function modals() {
  $('.js-modal').easyModal({
    top: 200,
    transitionIn: 'slidein',
    transitionOut: 'slideout',
    closeButtonClass: '.js-modal-close'
  });

  $('.js-modal-open').click(function(e) {
    var target = $(this).attr('href');
    $(target).trigger('openModal');
    e.preventDefault();
  });

  $('.js-modal-close').click(function(e) {
    $('.js-modal').trigger('closeModal');
  });

  var updateStructureTypes = function($modal) {
    var $structureTypes = $modal.find('.js-structure-types'),
        $structureSubtypes = $modal.find('.js-structure-subtypes'),
        parentStructureTypeId = $modal.find('.js-parent-structure-type').val(),
        selectedTypeId = $structureTypes.val(),
        options = '';

    $.ajax({ url: '/structure_types/' + parentStructureTypeId + '/subtypes',
             method: 'GET',
             data: { selected: selectedTypeId }})
     .done(function(data) {
       for (var i=0; i < data['types'].length; i++) {
         if (selectedTypeId == data['types'][i][1]) {
           options += '<option selected value="'+ data['types'][i][1]+'">'+data['types'][i][0]+'</option>';
         } else {
           options += '<option value="'+ data['types'][i][1]+'">'+data['types'][i][0]+'</option>';
         }
       }
       $structureTypes.html(options);

       options = '';
       for (var i=0; i < data['subtypes'].length; i++) {
         options += '<option value="'+ data['subtypes'][i][1]+'">'+data['subtypes'][i][0]+'</option>';
       }
       $structureSubtypes.html(options);
     });
  };

  $('.js-update-subtypes').on('click', function() {
    var $link = $(this),
        $modal = $($link.attr('href')),
        structureTypeId = $link.data('structure-type-id');

    $modal.find('.js-structure-types').html('');
    $modal.find('.js-structure-subtypes').html('');
    $modal.find('.js-parent-structure-type').val(structureTypeId);
    updateStructureTypes($modal);
  });

  $('#new_structure #structure_type').on('change', function() {
    var $modal = $(this).parents('.js-modal');
    updateStructureTypes($modal);
  });
});

// Autosubmit fields on blur
// --------------------------------
$(function autosubmitForms() {
  $('.js-autosave-form').on('change', 'input,textarea,select', function() {
    $(this).parents('form').submit();
  });
});
// Submit measure fields when the checkbox or notes change
//----------------------------------
$(function trackMeasures() {
  $measures = $('.active-content__measures');
  $measures.on('change', '.notes-toggler', function() {
    $(this).parents('form').submit();
  })

  $measures.on('blur', '.measure-notes', function() {
    $(this).parents('form').submit();
  });
});

// Make sure content area height eq or greater than sidebar
//----------------------------------------------------------
$(function contentMinHeight() {
  $('.js-active-content').css({
    'min-height':($('.js-sidebar-nav').height()+'px')
  });
});


// Animate page notice in/out
//----------------------------
$(function fadeNotice() {
  $('.js-flash-notice').fadeIn().delay(3000).slideUp();
});

$('.js-gallery').fancybox();



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

