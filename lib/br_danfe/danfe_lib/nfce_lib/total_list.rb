module BrDanfe
  module DanfeLib
    module NfceLib
      class TotalList
        require 'bigdecimal'

        def initialize(pdf, xml)
          @pdf = pdf
          @xml = xml
        end

        def render
          subtotal
          @pdf.draw_horizontal_line
          totals
          @pdf.draw_horizontal_line
          payment_methods
        end

        private

        def subtotal
          @pdf.render_blank_line
          cursor = @pdf.cursor
          @pdf.bounding_box [3.6.cm, cursor], width: 1.4.cm, height: 0.4.cm do
            @pdf.text 'Subtotal R$', size: 8, align: :left
          end
          @pdf.bounding_box [5.cm, cursor], width: 2.cm, height: 0.4.cm do
            @pdf.text BrDanfe::Helper.numerify(@xml['ICMSTot > vProd'].to_f), size: 8, align: :right
          end
        end

        def totals
          @pdf.render_blank_line

          cursor = @pdf.cursor
          print_text('QTD. TOTAL DE ITENS', cursor, size: 8, align: :left)
          print_text(@xml.css('det').count.to_s, cursor, size: 8, align: :right)

          cursor = @pdf.cursor
          print_text('DESCONTO R$', cursor, size: 8, align: :left)
          print_text(BrDanfe::Helper.numerify(@xml['ICMSTot > vDesc'].to_f), cursor, size: 8, align: :right)

          cursor = @pdf.cursor
          print_text('VALOR TOTAL R$', cursor, size: 8, align: :left, style: :bold)
          print_text(BrDanfe::Helper.numerify(@xml['ICMSTot > vNF'].to_f), cursor, size: 8, align: :right, style: :bold)
        end

        def payment_methods
          payments = {}
          without_payment = '90'

          @xml.css('detPag').each do |detPag|
            next if detPag.css('tPag').text == without_payment

            payments[detPag.css('tPag').text] ||= BigDecimal('0')
            actual_payment_value = BigDecimal(detPag.css('vPag').text)
            payments[detPag.css('tPag').text] += actual_payment_value
          end

          if payments.present?
            @pdf.render_blank_line

            cursor = @pdf.cursor
            print_text('FORMA PAGTO.', cursor, size: 8, align: :left, style: :bold)
            print_text('VLR PAGO R$', cursor, size: 8, align: :right, style: :bold)

            payments.each do |key, value|
              cursor = @pdf.cursor
              print_text(I18n.t("nfce.payment_methods.#{key}"), cursor, size: 8, align: :left)
              print_text(BrDanfe::Helper.numerify(value.to_f), cursor, size: 8, align: :right)
            end
          end
        end

        def print_text(text, cursor, options)
          @pdf.bounding_box [0, cursor], width: 7.cm, height: 0.35.cm do
            @pdf.text text, options
          end
        end
      end
    end
  end
end
