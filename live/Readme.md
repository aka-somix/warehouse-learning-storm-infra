# Cartella Live

Questa cartella contiene le configurazioni dell'infrastruttura deployata nel progetto. 
Staccare le configurazioni dalla definizione di infrastruttura ci permette di riproporre lo stesso gruppo di risorse in diverse situazioni
modificando un unico gruppo di file centrali, piuttosto che dover andare in ogni file terraform i parametri da modificare.

**Attenzione**
In questo progetto di esempio molte delle configurazioni sono state comunque lasciate nei file terraform per semplicità. Ovviamente non c'è una regola aurea per cosa spostare nelle configurazioni terragrunt e cosa no, si fa sempre riferimento alla scelta progettuale fatta all'inizio.

## File Terragunt.hcl
I file terragrunt.hcl fanno da connettori tra i vari moduli terragrunt e tra essi e i file all'esterno. 
Attraverso questi file è possibile definire degli input per i moduli, delle variabili locali e delle dipendenze che serviranno a terragrunt a stabilire un 
*"piano di azione"* per ogni volta che si esegue un "apply" dell'infrastruttura.

Inoltre, si possono leggere e importare delle variabili di configurazione anche da file json o yaml (vedi globals.yml).


## File di Lock

I file Terragrunt.lock.hcl sono utilizzati per definire un ambiente preciso di deploy del progetto. Questi permettono di persistere esattamente quale versione di tutti i registry terraform è stata utilizzata nell'ultima inizializzazione dell'infrastruttura.

Vengono generati dai `terraform init` ed è sempre consigliato rigenerarli quando si vuole passare ad una versione più aggiornata dei registry utilizzati. 

