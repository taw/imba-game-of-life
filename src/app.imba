let def countNeighbours(cells, x, y)
  let count = 0
  for i, cell of cells
    if !cell:state
      continue
    let dx = Math.abs(cell:x - x)
    let dy = Math.abs(cell:y - y)
    if Math.max(dx, dy) == 1
      count += 1
  return count

let def runStep(cells)
  let nextCells = []
  for i, cell of cells
    let n = countNeighbours(cells, cell:x, cell:y)
    let nextState = (n == 3 || (cell:state && n == 2))
    nextCells.push({x: cell:x, y: cell:y, state: nextState})
  return nextCells

tag CellTag < svg:g
  def onclick
    data:state = !data:state
    trigger("pause")

  def render
    let visualStartX = 20 * data:x + 1
    let visualStartY = 20 * data:y + 1

    <self>
      <svg:rect .alive=(data:state) .dead=(!data:state) x=visualStartX y=visualStartY height=18 width=18>

tag App
  def setup
    let sizex = 30
    let sizey = 30
    @cells = []
    for x in [0..sizex]
      for y in [0..sizey]
        @cells.push({ x: x, y: y, state: Math.random() < 0.2 })

  def step
    @cells = runStep(@cells)

  def mount
    setInterval(&,100) do
      if @playing
        step
      Imba.commit

  def play
    @playing = true

  def pause
    @playing = false

  def onpause
    pause

  def render
    <self>
      <header>
        "Game of Life"
      <svg:svg>
        for cell in @cells
          <CellTag[cell]>
      <div.buttons>
        if @playing
          <button :click.pause>
            "Pause"
        else
          <button :click.step>
            "Step"
          <button :click.play>
            "Play"

Imba.mount <App>
