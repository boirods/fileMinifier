#!/bin/bash

#Este código é somente para verificar se o arquivo é reduzido com o comentário
#com o caractere hashtag, lembrando que o arquivo com .min não dá para ser
#executado (a não ser que seja corrigido o código)

#inicia a função principal
 main()
 {
   echo "Escolha uma opção:"
   echo "1 - Esvaziar a lixeira"
   echo "2 - Calcular fatorial"
   read opcao;
   case $opcao in
   "1")
    esvaziar_lixeira
    ;;
   "2")
    calcular_fatorial
    ;;
 esac
}
esvaziar_lixeira()
{
  echo "Esvaziando a lixeira..."
  path="${HOME}/.local/share/Trash/files"
  cd "$path"
  for file in *
  do
  rm -rf "$file" # remove arquivos da lixeira...
  done
  echo "Done!"
}

###################################
# Função para calcular o fatorial #
###################################
calcular_fatorial()
{
  echo "Informe um número:"
  read numero;
  i=1
  fat=1
  while [ $i -le $numero ]
  do
  fat=$(($fat*$i))
  i=$(($i+1))
  done
  echo "fatorial de $numero é $fat"
}
main
# para ver o resultado veja o arquivo com o final .min
# codigo retirado da página abaixo:
# https://www.devmedia.com.br/introducao-ao-shell-script-no-linux/25778