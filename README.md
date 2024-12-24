# Semáforo Controlado com FSM em VHDL

Este projeto implementa um sistema de semáforo utilizando VHDL, com lógica de controle baseada em uma máquina de estados finita (FSM). O sistema é projetado para simular um cruzamento com três conjuntos de luzes e operar em um modo de segurança acionado por um botão.
## Tecnologias Utilizadas

- **VHDL:** Linguagem de descrição de hardware utilizada para implementar a máquina de estados finita (FSM).
- **FPGA DE0-Nano da Altera (Intel):** A placa de desenvolvimento foi usada para implementar e testar o sistema em hardware real.
- **Quartus:** Ambiente de desenvolvimento utilizado para compilar o código VHDL, simular e carregar o design na FPGA.
  
## Funcionalidades
- **Controle de Estados:**
  - Estados pré-definidos para cada fase do semáforo.
  - Transições suaves entre os estados, com tempos configuráveis.
  - Estado de segurança para emergências.
- **Configuração de Tempos:**
  - Personalize os tempos de verde, amarelo, inicialização, segurança e erro diretamente no código.
- **Modo de Segurança:**
  - Acionamento de um estado seguro (todas as luzes vermelhas) via botão externo.
- **Sinais de Saída:**
  - Cada saída (`s1`, `s2`, `s3`) é um vetor de 3 bits representando o estado das luzes: vermelho, amarelo ou verde.

### Diagrama de funcionalidade do Semáforo

![Diagrama de funcionalidade](imagens/simulação_waveform.png)

## Estrutura do Sistema
### Estados da FSM:
1. **Estado Inicial (`estado_inicial_reset`):**
   - Realiza um teste luminoso em todas as luzes.
   - Dura 2 segundos por padrão.
2. **Estados de Operação (`estadoA` a `estadoF`):**
   - Alternam as luzes em ciclos configuráveis (verde e amarelo).
   - Cada estado controla os sinais correspondentes para diferentes direções do semáforo.
3. **Estado de Segurança (`estado_safety`):**
   - Ativado pelo botão de emergência.
   - Mantém todas as luzes vermelhas por um período configurável (5 segundos por padrão).
4. **Estado de Erro (`others`):**
   - Garante que qualquer estado desconhecido redirecione o sistema para uma operação segura.

### Configuração dos Tempos:
- Os tempos são definidos em ciclos de clock e podem ser ajustados por constantes:
  - **`tempo_inicial`**: 2 segundos.
  - **`tempo_verde`**: Entre 5 e 10 segundos.
  - **`tempo_amarelo`**: Entre 2 e 5 segundos.
  - **`tempo_safety`**: 5 segundos.
  - **`tempo_erro`**: 5 segundos.

### FSM

![Diagrama de FSM](imagens/state_machine_viewer.png)

### Componentes e Sinais:
- **Latch JK:**
  - Captura o estado do botão de emergência (`btm`).
- **Contador:**
  - Controla os tempos de cada estado.
- **Saídas (`s1`, `s2`, `s3`):**
  - Vetores de 3 bits que indicam as cores do semáforo:
    - `"100"`: Vermelho.
    - `"011"`: Verde-Amarelo.
    - `"001"`: Verde.
    - `"111"`: Teste luminoso.

### Diagrama do RTL

![Diagrama do RTL](imagens/RTL_viewer.png)

## Utilização da FPGA DE0-Nano da Altera

A **FPGA DE0-Nano** é uma placa compacta de desenvolvimento baseada no chip **Cyclone IV** da Altera (Intel). Ela oferece 40 pinos I/O, memória SRAM de 2 Mbit, e é ideal para projetos digitais e sistemas embarcados.

### Como Utilizar:
1. **Desenvolvimento do Código VHDL:** O código VHDL é compilado no **Quartus** e pode ser carregado na FPGA DE0-Nano.
2. **Mapeamento de Entradas e Saídas:** Conecte LEDs para representar as luzes do semáforo e use um botão para acionar o modo de segurança.
3. **Programação da FPGA:** Após compilar o código no **Quartus**, use a ferramenta USB-Blaster para carregar o design na FPGA.

## Ambiente de Simulação: Quartus

O **Quartus** é o ambiente de desenvolvimento integrado (IDE) utilizado para desenvolver e simular o design da FPGA. Ele oferece ferramentas para compilação, simulação, depuração e programação de dispositivos FPGA.

### Passos para Utilização:
1. **Instalação do Quartus:** Baixe e instale o **Quartus Prime Lite Edition** (versão gratuita).
2. **Criação do Projeto:** No Quartus, crie um novo projeto e selecione a FPGA correta (Cyclone IV EP4CE22F17C8N).
3. **Desenvolvimento e Simulação:** Implemente o código VHDL para a FSM do semáforo e simule o comportamento utilizando o **ModelSim**.
4. **Compilação:** Compile o código para gerar o arquivo de configuração `.sof` que será carregado na FPGA.
5. **Programação:** Conecte a **DE0-Nano** ao PC via USB-Blaster e carregue o arquivo de configuração na FPGA.

## Como Usar
1. Clone o repositório:
   ```bash
   git clone https://github.com/erickdiias/Semaforo_Controlado_com_FSM_em_VHDL.git
