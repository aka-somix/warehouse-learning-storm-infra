# Cartella Modules

Questa cartella contiene tutte le definizioni dell'infrastruttura Terraform (quindi principalmente file *".tf"*).  

## Cosa sono i Moduli?

Ogni modulo è un'unità di infrastruttura deployabile indipendentemente dalle altre. Dall'esterno può essere visto come una black box con una serie di input e output. 
In generale, infatti, in ogni modulo definiamo un file *input.tf* e un *output.tf*. 

I moduli possono avere delle dipendenze tra loro che sono rappresentate nella configurazione terragrunt ([vedi documentazione cartella /live](../live/About.md))  

Principalmente attribuiamo ai moduli un significato funzionale. Ovvero ogni modulo servirà a fornire e gestire una sola funzionalità. E' importante gestire le dipendenze tra moduli con una **struttura ad Albero**, prestando particolare attenzione a non introdurre **dipendenze cicliche**  

  
Ogni modulo può vedere tutti i file .tf senza bisogno di importarli esplicitamente, questo aiuta ad organizzare l'infrastruttura in più file in maniera più ordinata.

## Moduli in questo Progetto
Nelle cartelle di ogni modulo è possibile trovare un file Readme che spiega la funzione di ognuno.