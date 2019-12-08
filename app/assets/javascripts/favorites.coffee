# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# 無限スクロールの記述
$ ->
  $('.jscroll').jscroll
  	# 要素の指定
    contentSelector: '.infinite-list'
    # 次のページのリンクを指定
    nextSelector: 'span.next:last a'
  return

# スクロールした際に自動的に次の要素を読み込む処理
$(window).on 'scroll', ->
  scrollHeight = $(document).height()
  scrollPosition = $(window).height() + $(window).scrollTop()
  if (scrollHeight - scrollPosition) / scrollHeight <= 0.05
    # スクロールの位置が下部5%の範囲に来た場合
    $('.jscroll').jscroll
      contentSelector: '.infinite-list'
      nextSelector: 'span.next:last a'
    return
  return