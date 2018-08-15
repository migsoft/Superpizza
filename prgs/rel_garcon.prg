/*
  sistema     : superchef pizzaria
  programa    : relat�rio comiss�o gar�ons
  compilador  : xharbour 1.2 simplex
  lib gr�fica : minigui 1.7 extended
  programador : marcelo neves
*/

#include 'minigui.ch'
#include 'miniprint.ch'
#include 'super.ch'

function relatorio_garcon()

         local a_001 := {}

         dbselectarea('atendentes')
         atendentes->(ordsetfocus('nome'))
         atendentes->(dbgotop())
         while .not. eof()
               aadd(a_001,strzero(atendentes->codigo,4)+' - '+atendentes->nome)
               atendentes->(dbskip())
         end

         define window form_comissao_garcon;
                at 000,000;
                width 400;
                height 250;
                title 'Comiss�o Atendentes/Gar�ons';
                icon path_imagens+'icone.ico';
                modal;
                nosize

                @ 010,010 label lbl_001;
                          of form_comissao_garcon;
                          value 'Escolha o intervalo de datas';
                          autosize;
                          font 'tahoma' size 010;
                          bold;
                          fontcolor _preto_001;
                          transparent
                @ 080,010 label lbl_002;
                          of form_comissao_garcon;
                          value 'Escolha o atendente/gar�on';
                          autosize;
                          font 'tahoma' size 010;
                          bold;
                          fontcolor _preto_001;
                          transparent

                @ 040,010 datepicker dp_inicio;
                          parent form_comissao_garcon;
                          value date();
                          width 150;
                          height 030;
                          font 'verdana' size 014
                @ 040,170 datepicker dp_final;
                          parent form_comissao_garcon;
                          value date();
                          width 150;
                          height 030;
                          font 'verdana' size 014
		          define combobox cbo_001
			              row	110
                       col	010
			              width 310
			              height 200
			              items a_001
			              value 1
                end combobox

                * linha separadora
                define label linha_rodape
                       col 000
                       row form_comissao_garcon.height-090
                       value ''
                       width form_comissao_garcon.width
                       height 001
                       backcolor _preto_001
                       transparent .F.
                end label

                * bot�es
                define button button_ok
                       picture path_imagens+'img_relatorio.bmp'
                       col form_comissao_garcon.width-255
                       row form_comissao_garcon.height-085
                       width 150
                       height 050
                       caption 'Ok, imprimir'
                       action relatorio()
                       fontbold .T.
                       tooltip 'Gerar o relat�rio'
                       flat .F.  //                    noxpstyle .T.
                end button
                define button button_cancela
                       picture path_imagens+'img_sair.bmp'
                       col form_comissao_garcon.width-100
                       row form_comissao_garcon.height-085
                       width 090
                       height 050
                       caption 'Voltar'
                       action form_comissao_garcon.release
                       fontbold .T.
                       tooltip 'Sair desta tela'
                       flat .F.  //                       noxpstyle .T.
                end button

                on key escape action thiswindow.release

         end window

         form_comissao_garcon.center
         form_comissao_garcon.activate

         return(nil)
*-------------------------------------------------------------------------------
static function relatorio()

       local x_codigo_garcon := 0
       local x_de            := form_comissao_garcon.dp_inicio.value
       local x_ate           := form_comissao_garcon.dp_final.value
       local x_garcon        := form_comissao_garcon.cbo_001.value

       local p_linha := 046
       local u_linha := 260
       local linha   := p_linha
       local pagina  := 1
       
       local x_subtotal := 0
       local x_total    := 0
       local x_old_data := ctod('  /  /  ')

       x_codigo_garcon := val(substr(form_comissao_garcon.cbo_001.item(x_garcon),1,4))

       dbselectarea('comissao_mesa')
       index on dtos(data)+hora to indcatb for data >= x_de .and. data <= x_ate .and. id == x_codigo_garcon
       go top

       SELECT PRINTER DIALOG PREVIEW

       START PRINTDOC NAME 'Gerenciador de impress�o'
       START PRINTPAGE

       cabecalho(pagina)
       
       while .not. eof()

             x_subtotal := x_subtotal + valor
             x_old_data := data
             
             @ linha,030 PRINT dtoc(data) FONT 'courier new' SIZE 010
             @ linha,060 PRINT hora FONT 'courier new' SIZE 010
             @ linha,100 PRINT trans(valor,'@E 9,999.99') FONT 'courier new' SIZE 010

             linha += 5
             
             if linha >= u_linha
                END PRINTPAGE
                START PRINTPAGE
                pagina ++
                cabecalho(pagina)
                linha := p_linha
             endif
             
             skip

             if data <> x_old_data
                linha += 5
                @ linha,070 PRINT 'Subtotal Comiss�es : R$ '+trans(x_subtotal,'@E 9,999.99') FONT 'courier new' SIZE 010
                linha += 5
                @ linha,030 PRINT LINE TO linha,150 PENWIDTH 0.3 COLOR _preto_001
                linha += 3
                x_total := x_total + x_subtotal
                x_subtotal := 0
             endif
             
       end

       linha += 5
       @ linha,070 PRINT 'Total COMISS�ES : R$ '+trans(x_total,'@E 9,999.99') FONT 'courier new' SIZE 010

       rodape()
       
       END PRINTPAGE
       END PRINTDOC

       return(nil)
*-------------------------------------------------------------------------------
static function cabecalho(p_pagina)

       local x_codigo_garcon := 0
       local x_de            := form_comissao_garcon.dp_inicio.value
       local x_ate           := form_comissao_garcon.dp_final.value
       local x_garcon        := form_comissao_garcon.cbo_001.value
       x_codigo_garcon       := val(substr(form_comissao_garcon.cbo_001.item(x_garcon),1,4))
       
       @ 007,010 PRINT IMAGE path_imagens+'logotipo.bmp' WIDTH 050 HEIGHT 020 STRETCH
       @ 010,070 PRINT 'COMISS�O ATENDENTE/GAR�ON' FONT 'courier new' SIZE 018 BOLD
       @ 018,070 PRINT dtoc(x_de)+' at� '+dtoc(x_ate) FONT 'courier new' SIZE 014
       @ 024,070 PRINT 'De     : '+acha_atendente(x_codigo_garcon) FONT 'courier new' SIZE 012
       @ 030,070 PRINT 'p�gina : '+strzero(p_pagina,4) FONT 'courier new' SIZE 012

       @ 036,000 PRINT LINE TO 036,205 PENWIDTH 0.5 COLOR _preto_001

       @ 041,030 PRINT 'DATA' FONT 'courier new' SIZE 010 BOLD
       @ 041,060 PRINT 'HORA' FONT 'courier new' SIZE 010 BOLD
       @ 041,100 PRINT 'VALOR R$' FONT 'courier new' SIZE 010 BOLD

       return(nil)
*-------------------------------------------------------------------------------
static function rodape()

       @ 275,000 PRINT LINE TO 275,205 PENWIDTH 0.5 COLOR _preto_001
       @ 276,010 PRINT 'impresso em '+dtoc(date())+' as '+time() FONT 'courier new' SIZE 008

       return(nil)