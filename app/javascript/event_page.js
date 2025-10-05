import jquery from 'jquery';
window.$ = window.jQuery = jquery;

import "bootstrap";
import 'jquery-mask-plugin';
// import './company_module/event_pages/form_buy_ticket';

$('.phone-mask').mask('(00) 0000-0000');
$('.cellphone-mask').mask('(00) 9 0000-0000');
$('.cpf-mask').mask('000.000.000-00');  

document.addEventListener("turbo:load", () => {
  console.log("jQuery version:", $.fn.jquery);
});