local io = require('io')


function exibeMensagemInicial(arquivo)
	print("---------------------------")
	print("- Minimizador de arquivos -")
	print("---------------------------")
	if arquivo == nil then
		print('Digite o caminho completo do arquivo que você deseja minimizar:')
		arquivo=io.read()
	end
	return arquivo
end

function removeHtmlComments(textoDoArquivoMinificado)
	local padrao = {"<!--", "%-%->"} --se a string desejada der errado tente colocando o caractere % na frente dos caracteres ignorados
	local possuiComentarios = true
	while possuiComentarios do
		local inicioComentario = {}
		inicioComentario = string.find(textoDoArquivoMinificado, padrao[1])
		local fimComentario = {}
		fimComentario = string.find(textoDoArquivoMinificado, padrao[2])
		if inicioComentario ~= nil and fimComentario ~= nil then
			possuiComentarios = true
		else
			return textoDoArquivoMinificado
		end
		local inicioComentario, teste = string.find(textoDoArquivoMinificado, padrao[1]) -- saber onde inicia o comentário
		local teste, fimComentario = string.find(textoDoArquivoMinificado, padrao[2])    -- saber onde termina o comentário

		local inicioTexto = string.sub(textoDoArquivoMinificado, 1, inicioComentario - 1)                            -- pega o inicio do texto até antes de iniciar o comentário
		local fimTexto = string.sub(textoDoArquivoMinificado, fimComentario + 1, string.len(textoDoArquivoMinificado)) -- pega o fim do texto de onde termina o comentário até o fim do código

		textoDoArquivoMinificado = inicioTexto.. fimTexto
	end
end

function removeJavaMultipleLineComments(textoDoArquivoMinificado)
	local padrao = {"/%*", "%*/"}
	local possuiComentarios = true
	while possuiComentarios do
		local inicioComentario = {}
		inicioComentario = string.find(textoDoArquivoMinificado, padrao[1])
		local fimComentario = {}
		fimComentario = string.find(textoDoArquivoMinificado, padrao[2])
		if inicioComentario ~= nil and fimComentario ~= nil then
			possuiComentarios = true
		else
			return textoDoArquivoMinificado
		end
		local inicioComentario, teste = string.find(textoDoArquivoMinificado, padrao[1])
		local teste, fimComentario = string.find(textoDoArquivoMinificado, padrao[2])

		local inicioTexto = string.sub(textoDoArquivoMinificado, 1, inicioComentario -1)
		local fimTexto = string.sub(textoDoArquivoMinificado, fimComentario + 1, string.len(textoDoArquivoMinificado))

		textoDoArquivoMinificado = inicioTexto.. fimTexto
	end
end

function removeSingleLineComments(linha)
	local padrao = {"//", "#"}
	local posicaoBarraBarra=0
	if string.find(linha, padrao[1]) then
		posicaoBarraBarra = string.find(linha, padrao[1])

		if temDoisPontosAntesBarraBarra(linha, posicaoBarraBarra) then
			return linha
		else 
			--testa //
			local inicio, fim = string.find(linha, padrao[1])
			linha = string.sub(linha, 1, inicio - 1)
			return linha
		end
	elseif string.find(linha, padrao[2]) ~= nil then
		--testa #
		local inicio, fim = string.find(linha, padrao[2])
		linha = string.sub(linha, 1, inicio - 1)
		return linha
	else
		return linha
	end
end

function temDoisPontosAntesBarraBarra(linha, posicaoBarraBarra)
	local posicaoDoisPontos = string.find(linha, ':')
	if posicaoDoisPontos == (posicaoBarraBarra - 1) then
		return true
	end
end

function minificaArquivo(arquivo)
	local primeiraLinha = ''
	for linha in io.lines(arquivo) do
		--remove \t (tabulações na linha)
		linha = string.gsub(linha, "\t+","")
		--[[ Colocar abaixo removedores de comentários que devem ser feitos durante a remoção de tabulações (\t) --]]
		linha = removeSingleLineComments(linha)
		--[[ Fim de removedores de comentários]]
		primeiraLinha = primeiraLinha .. linha
	end
	--[[ Colocar abaixo removedores de comentários que possuem caracteres que iniciam e terminam de modos diferentes, como comentários de html e de java com multiplas linhas --]]
	primeiraLinha = removeHtmlComments(primeiraLinha)
	primeiraLinha = removeJavaMultipleLineComments(primeiraLinha)
	--[[ fim de removedores de comentários]]
	return primeiraLinha
end

function geraESalvaArquivoMinificado(primeiraLinha)
	local novoArquivo = arquivo..'.min'
	print("\n\nO arquivo foi salvo em: ".. novoArquivo)
	return novoArquivo, primeiraLinha
end

function salvaArquivo(caminho, primeiraLinha)
	arquivo = io.open(caminho, 'w+')
	arquivo:write(primeiraLinha)
	arquivo:flush()
	arquivo:close()
end

arquivo = exibeMensagemInicial()
minificado = minificaArquivo(arquivo) --chamar para minificar os comentários de html nesta função
salvaArquivo(geraESalvaArquivoMinificado(minificado))