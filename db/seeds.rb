### CRIAÇÃO DOS GOLEIROS
[
  { name: 'Jesher Minelli', nickname: 'Jesher', number: 22 },
  { name: 'Paulo Golero', nickname: 'Paulão', number: 12 },
  { name: 'José Carlos', nickname: 'Zé Carlos', number: 44 },
  { name: 'Gustavo', nickname: 'Gustavo', number: 11 }
].each do |player|
  Player.create!(
    name: player[:name],
    nickname: player[:nickname],
    number: player[:number]
  )
end

## CRIAÇÃO DOS JOGADORES DE LINHA
[
  { name: 'Ana Duarte', nickname: 'Ana', number: 11 },
  { name: 'Renan Poli', nickname: 'Renan', number: 94 },
  { name: 'Michele', nickname: 'Michele', number: 20 },
  { name: 'Paulo Duarte', nickname: 'Paulinho', number: 8 },
  { name: 'Daniel Duarte', nickname: 'Daniel', number: 7 },
  { name: 'Devair Alberto', nickname: 'Devinha', number: 10 },
  { name: 'Eduardo Duarte', nickname: 'Pê', number: 5 },
  { name: 'Fabio Silva', nickname: 'Fabim', number: 2 },
  { name: 'Leonardo', nickname: 'Léo', number: 0 },
  { name: 'Marcos Munari', nickname: 'Marcão', number: 9 },
  { name: 'Emerson Soares', nickname: 'Emerson', number: 17 },
  { name: 'Mateus Duarte', nickname: 'Mateus', number: 6 },
  { name: 'Lucas Duarte', nickname: 'Lucas', number: 4 },
  { name: 'Francisco Duarte', nickname: 'Gordo', number: 14 },
  { name: 'Ronaldo Duarte', nickname: 'Nardim', number: 28 },
  { name: 'Francisco', nickname: 'Francisco', number: 30 },
  { name: 'Fernando Duarte', nickname: 'Fernando', number: 3 },
  { name: 'Wilian', nickname: 'Wilian', number: 10 },
  { name: 'Lincoln Souza', nickname: 'Lincoln', number: 88 },
  { name: 'Luan Henrique', nickname: 'Luan', number: 99 },
  { name: 'João Gabriel', nickname: 'João', number: 20 },
  { name: 'Gabriel', nickname: 'Gabriel', number: 180 }
].each do |player|
  Player.create!(
    name: player[:name],
    nickname: player[:nickname],
    number: player[:number]
  )
end

# User.create!(name: 'Jesher Minelli', email: 'jesherdevsk8@gmail.com', password: 'senha@123')
