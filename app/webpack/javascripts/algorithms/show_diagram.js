$(function() {
  paper_on_load();

  function on_solve_step(is_final) {
    draw_diagram();
  }

  // paper

  function draw_diagram() {
    let algorithm_json = JSON.parse($('#algorithm_json').val());
    let existing_trace_json = JSON.parse($('#existing_trace_json').val());
    const elem = $('#diagram_area');
    const pos = elem.offset();
    const width = elem.width();
    const height = elem.height();
    // console.log("pos:", pos);
    const point = [pos.left, pos.top];
    const size = [width, height];

    redraw_activity_diagram(algorithm_json, existing_trace_json, {viewport: {point, size}});
  }

  function paper_on_load() {
    if (!window.globals || !window.globals.paper_init) {
      setTimeout(paper_on_load, 200);
      console.log("Waiting for paperscript loaded ...")
      return;
    }

    console.log("paper_on_load() ...")
    window.globals.paper_init();
    diagram_init();
    console.log("paper_on_load() OK.")

    // отрисовать диаграмму в первый раз
    draw_diagram();

    // /// test canvas
    // var myCircle = new paper.Path.Circle(new paper.Point(600, 170), 150);
    // myCircle.fillColor = 'black';
    // // console.log(myCircle);
  }

  // /paper
});
