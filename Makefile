all :
	@flex++ MarkAIML.l 
	@g++ lex.yy.cc -o MarkAIML 
	@./MarkAIML ejemploMarkAiml.txt salida.aiml 
	@mv ./salida.aiml ./programAB/bots/mybot/aiml
	@echo "El archivo se ha movido a <programAB/bots/mybot/aiml> . Puedes ver el archivo ahí o ejecutar el programa y probarlo."

