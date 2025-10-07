import jquery from 'jquery';
window.$ = window.jQuery = jquery;

import "bootstrap";
import select2 from "select2";
import 'vanilla-nested';
import 'jquery-mask-plugin';

select2($);

$('.select2').select2({
  tags: true,
  allowClear: true
})

$('.select2-multiple').select2({
  tags: true,
  allowClear: true,
  multiple: true
})

$('.phone-mask').mask('(00) 0000-0000');
$('.cellphone-mask').mask('(00) 9 0000-0000');
$('.cpf-mask').mask('000.000.000-00');
