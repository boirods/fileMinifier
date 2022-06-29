# fileMinifier
Minificador de arquivos feito com a linguagem lua
### O que o file minifier faz?
Remove os itens abaixo de seu código:
- [x] quebras de linhas ('\n')
- [x] Tabulações ('\t')
- [x] comentários com '//'
- [x] comentários que começam com '#'
- [x] comentários que começam e terminam com '/*' e '*/'
- [x] comentários que começam e terminam com '< ! - - ' e '- - >' (coloquei separado pois fica comentado os caracteres)

### Tá, legal ele remove deixando o arquivo menor, mas qual a utilidade disto??
Bom você pode reduzir os arquivos de tamanho para serem enviados com uma internet com conexão ruim, isso ajuda quando você acessa arquivos muito grandes na internet. Algumas vezes que vc acessa um site ele não fica carregando?? então com isso o site irá carregar mais rápido... do que um arquivo com muito comentário e tabulações e linhas