require 'spec_helper'

describe BrDanfe::DanfeLib::Infadic do
  let(:base_dir) { './spec/fixtures/nfe/lib/' }
  let(:output_pdf) { "#{base_dir}output.pdf" }

  let(:pdf) { BrDanfe::DanfeLib::Document.new }
  let(:xml) { BrDanfe::DanfeLib::XML.new(xml_as_string) }

  subject { described_class.new(pdf, xml) }

  describe '#render' do
    let(:volumes_number) { 1 }

    before do
      subject.render(volumes_number)
      File.delete(output_pdf) if File.exist?(output_pdf)
    end

    context 'when there is no information' do
      let(:xml_as_string) do
        <<-EOS
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
              <transp>
                <vol>
                  <qVol>1</qVol>
                  <esp>VOLUMES 1</esp>
                  <marca>DIVERSOS 1</marca>
                  <nVol>1</nVol>
                  <pesoL>1000.000</pesoL>
                  <pesoB>1100.000</pesoB>
                </vol>
                <vol>
                  <qVol>2</qVol>
                  <esp>VOLUMES 2</esp>
                  <marca>DIVERSOS 2</marca>
                  <nVol>2</nVol>
                  <pesoL>2000.000</pesoL>
                  <pesoB>2200.000</pesoB>
                </vol>
                <vol>
                  <qVol>3</qVol>
                  <esp>VOLUMES 3</esp>
                  <marca>DIVERSOS 3</marca>
                  <nVol>3</nVol>
                  <pesoL>3000.000</pesoL>
                  <pesoB>3300.000</pesoB>
                </vol>
              </transp>
              <total>
                <ICMSTot>
                  <vFCPUFDest>4892.78</vFCPUFDest>
                  <vICMSUFRemet>75394.78</vICMSUFRemet>
                </ICMSTot>
              </total>
            </infNFe>
          </NFe>
        EOS
      end

      it 'renders title with box, subtitle and fisco box on the pdf' do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect(
          "#{base_dir}infadic#render.pdf"
        ).to have_same_content_of file: output_pdf
      end
    end

    context 'when has difal' do
      let(:xml_as_string) do
        <<-EOS
          <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
            <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
              <transp>
                <vol>
                  <qVol>1</qVol>
                  <esp>VOLUMES 1</esp>
                  <marca>DIVERSOS 1</marca>
                  <nVol>1</nVol>
                  <pesoL>1000.000</pesoL>
                  <pesoB>1100.000</pesoB>
                </vol>
                <vol>
                  <qVol>2</qVol>
                  <esp>VOLUMES 2</esp>
                  <marca>DIVERSOS 2</marca>
                  <nVol>2</nVol>
                  <pesoL>2000.000</pesoL>
                  <pesoB>2200.000</pesoB>
                </vol>
                <vol>
                  <qVol>3</qVol>
                  <esp>VOLUMES 3</esp>
                  <marca>DIVERSOS 3</marca>
                  <nVol>3</nVol>
                  <pesoL>3000.000</pesoL>
                  <pesoB>3300.000</pesoB>
                </vol>
              </transp>
              <total>
                <ICMSTot>
                  <vFCPUFDest>4892.78</vFCPUFDest>
                  <vICMSUFDest>2915.78</vICMSUFDest>
                  <vICMSUFRemet>75394.78</vICMSUFRemet>
                </ICMSTot>
              </total>
            </infNFe>
          </NFe>
        EOS
      end

      it 'renders title with box, subtitle, fisco box and difal on the pdf' do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect("#{base_dir}infadic#render-difal.pdf").to have_same_content_of file: output_pdf
      end
    end

    context 'when has too big address' do
      let(:xml_as_string) do
        <<-EOS
      <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
        <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
          <ide>
            <dEmi>2011-10-29</dEmi>
            <dSaiEnt>2011-10-30</dSaiEnt>
            <hSaiEnt>15:32:45</hSaiEnt>
          </ide>
          <dest>
            <CNPJ>82743287000880</CNPJ>
            <xNome>Schneider Electric Brasil Ltda</xNome>
            <enderDest>
              <xLgr>Av da Saudade</xLgr>
              <nro>1125</nro>
              <xBairro>Frutal</xBairro>
              <xCpl>Em anexo ao super mercado maior do bairro</xCpl>
              <cMun>3552403</cMun>
              <xMun>SUMARE</xMun>
              <UF>SP</UF>
              <CEP>13171320</CEP>
              <cPais>1058</cPais>
              <xPais>BRASIL</xPais>
              <fone>1921046300</fone>
            </enderDest>
            <IE>671008375110</IE>
          </dest>
        </infNFe>
      </NFe>
        EOS
      end

      it 'renders title with box, subtitle, fisco box and address on the pdf' do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect(
          "#{base_dir}infadic#render-with_street_data.pdf"
        ).to have_same_content_of file: output_pdf
      end
    end

    context 'when has complementary information' do
      let(:xml_as_string) do
        <<-EOS
      <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
        <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
          <ide>
            <dEmi>2011-10-29</dEmi>
            <dSaiEnt>2011-10-30</dSaiEnt>
            <hSaiEnt>15:32:45</hSaiEnt>
          </ide>
          <dest>
            <CNPJ>82743287000880</CNPJ>
            <xNome>Schneider Electric Brasil Ltda</xNome>
            <enderDest>
              <xLgr>Av da Saudade</xLgr>
              <nro>1125</nro>
              <xBairro>Frutal</xBairro>
              <xCpl>Sala 01 e 02</xCpl>
              <cMun>3552403</cMun>
              <xMun>SUMARE</xMun>
              <UF>SP</UF>
              <CEP>13171320</CEP>
              <cPais>1058</cPais>
              <xPais>BRASIL</xPais>
              <fone>1921046300</fone>
            </enderDest>
            <IE>671008375110</IE>
          </dest>
          <transp>
            <vol>
              <qVol>1</qVol>
              <esp>VOLUMES 1</esp>
              <marca>DIVERSOS 1</marca>
              <nVol>1</nVol>
              <pesoL>1000.000</pesoL>
              <pesoB>1100.000</pesoB>
            </vol>
            <vol>
              <qVol>2</qVol>
              <esp>VOLUMES 2</esp>
              <marca>DIVERSOS 2</marca>
              <nVol>2</nVol>
              <pesoL>2000.000</pesoL>
              <pesoB>2200.000</pesoB>
            </vol>
            <vol>
              <qVol>3</qVol>
              <esp>VOLUMES 3</esp>
              <marca>DIVERSOS 3</marca>
              <nVol>3</nVol>
              <pesoL>3000.000</pesoL>
              <pesoB>3300.000</pesoB>
            </vol>
          </transp>
          <infAdic>
            <infCpl>Uma observação</infCpl>
          </infAdic>
          <total>
            <ICMSTot>
              <vFCPUFDest>0.00</vFCPUFDest>
              <vICMSUFDest>0.00</vICMSUFDest>
              <vICMSUFRemet>0.00</vICMSUFRemet>
            </ICMSTot>
          </total>
        </infNFe>
      </NFe>
        EOS
      end

      it 'renders title with box, subtitle, fisco box and complementary ' \
        'information on the pdf' do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect(
          "#{base_dir}infadic#render-with_complementary_information.pdf"
        ).to have_same_content_of file: output_pdf
      end
    end

    context 'when has extra volume' do
      let(:xml_as_string) do
        <<-EOS
      <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
        <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
          <ide>
            <dEmi>2011-10-29</dEmi>
            <dSaiEnt>2011-10-30</dSaiEnt>
            <hSaiEnt>15:32:45</hSaiEnt>
          </ide>
          <dest>
            <CNPJ>82743287000880</CNPJ>
            <xNome>Schneider Electric Brasil Ltda</xNome>
            <enderDest>
              <xLgr>Av da Saudade</xLgr>
              <nro>1125</nro>
              <xBairro>Frutal</xBairro>
              <xCpl>Sala 01 e 02</xCpl>
              <cMun>3552403</cMun>
              <xMun>SUMARE</xMun>
              <UF>SP</UF>
              <CEP>13171320</CEP>
              <cPais>1058</cPais>
              <xPais>BRASIL</xPais>
              <fone>1921046300</fone>
            </enderDest>
            <IE>671008375110</IE>
          </dest>
          <transp>
            <vol>
              <qVol>1</qVol>
              <esp>VOLUMES 1</esp>
              <marca>DIVERSOS 1</marca>
              <nVol>1</nVol>
              <pesoL>1000.000</pesoL>
              <pesoB>1100.000</pesoB>
            </vol>
            <vol>
              <qVol>2</qVol>
              <esp>VOLUMES 2</esp>
              <marca>DIVERSOS 2</marca>
              <nVol>2</nVol>
              <pesoL>2000.000</pesoL>
              <pesoB>2200.000</pesoB>
            </vol>
            <vol>
              <qVol>3</qVol>
              <esp>VOLUMES 3</esp>
              <marca>DIVERSOS 3</marca>
              <nVol>3</nVol>
              <pesoL>3000.000</pesoL>
              <pesoB>3300.000</pesoB>
            </vol>
          </transp>
          <total>
            <ICMSTot>
              <vFCPUFDest>0.00</vFCPUFDest>
              <vICMSUFDest>0.00</vICMSUFDest>
              <vICMSUFRemet>0.00</vICMSUFRemet>
            </ICMSTot>
          </total>
        </infNFe>
      </NFe>
        EOS
      end
      let(:volumes_number) { 2 }

      it 'renders title with box, subtitle, fisco box and extra volumes on the ' \
      'pdf' do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect(
          "#{base_dir}infadic#render-extra_volume.pdf"
        ).to have_same_content_of file: output_pdf
      end
    end

    context 'when has all the informations' do
      let(:xml_as_string) do
        <<-EOS
        <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
          <infNFe Id="NFe25111012345678901234550020000134151000134151" versao="2.00">
            <dest>
            <CNPJ>82743287000880</CNPJ>
            <xNome>Schneider Electric Brasil Ltda</xNome>
            <enderDest>
              <xLgr>Av da Saudade</xLgr>
              <nro>1125</nro>
              <xBairro>Frutal</xBairro>
              <xCpl>Em anexo ao super mercado maior do bairro</xCpl>
              <cMun>3552403</cMun>
              <xMun>SUMARE</xMun>
              <UF>SP</UF>
              <CEP>13171320</CEP>
              <cPais>1058</cPais>
              <xPais>BRASIL</xPais>
              <fone>1921046300</fone>
            </enderDest>
            <IE>671008375110</IE>
            </dest>
            <transp>
              <vol>
                <qVol>1</qVol>
                <esp>VOLUMES 1</esp>
                <marca>DIVERSOS 1</marca>
                <nVol>1</nVol>
                <pesoL>1000.000</pesoL>
                <pesoB>1100.000</pesoB>
              </vol>
              <vol>
                <qVol>2</qVol>
                <esp>VOLUMES 2</esp>
                <marca>DIVERSOS 2</marca>
                <nVol>2</nVol>
                <pesoL>2000.000</pesoL>
                <pesoB>2200.000</pesoB>
              </vol>
              <vol>
                <qVol>3</qVol>
                <esp>VOLUMES 3</esp>
                <marca>DIVERSOS 3</marca>
                <nVol>3</nVol>
                <pesoL>3000.000</pesoL>
                <pesoB>3300.000</pesoB>
              </vol>
            </transp>
            <infAdic>
              <infCpl>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec congue in dolor sed sagittis.</infCpl>
            </infAdic>
            <ICMSTot>
              <vFCPUFDest>4892.78</vFCPUFDest>
              <vICMSUFDest>2915.78</vICMSUFDest>
              <vICMSUFRemet>75394.78</vICMSUFRemet>
            </ICMSTot>
          </infNFe>
        </NFe>
        EOS
      end
      let(:volumes_number) { 3 }

      it 'renders title with box, subtitle, fisco box, extra volumes, ' \
      'complementary information, address and difal on the pdf' do
        expect(File.exist?(output_pdf)).to be_falsey

        pdf.render_file output_pdf

        expect(
          "#{base_dir}infadic#render-all_the_informations.pdf"
        ).to have_same_content_of file: output_pdf
      end
    end
  end
end