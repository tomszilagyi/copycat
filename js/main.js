$(function() {
   $( '.video-list' ).searchable({
      selector      : 'span',
      childSelector : 'input',
      searchField   : '#search',
      searchType    : 'helm',
      ignoreDiacritics : true,
      getContent    : function( elem ) {
         return elem[0].value;
      },
      hide          : function( elem ) {
         elem.fadeOut(100);
      },
      show          : function( elem ) {
         elem.fadeIn(100);
      },
      onSearchActive : function( elem, term ) {
         elem.show();
      },
   });
});
