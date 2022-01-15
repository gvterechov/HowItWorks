import { paper_init } from './paper/paper-canvas';
import { diagram_init } from './paper/diagram';
import { redraw_activity_diagram } from './paper/activity-vis';


$(function() {
  paper_on_load();
});

export function on_solve_step(is_final) {
  draw_diagram();
}

// paper

function draw_diagram() {
  let algorithm_json_str = $('#algorithm_json').val();
  if (!algorithm_json_str || algorithm_json_str === 'indefined') {
    // no algorithm data available yet
    return;
  }

  let algorithm_json = JSON.parse(algorithm_json_str);
  let existing_trace_json = JSON.parse($('#existing_trace_json').val());
  // no need to do every time to: paper_init("my_paper_canvas");
  // `my_paper_canvas` is a real <canvas> element wth absolute positioning.
  // `diagram_area` is empty div inside grid - just to locate where to draw on canvas;
  const elem = $('#diagram_area');
  const pos = elem.offset();

  if (!pos) {
    // no diagram should be shown for this page
    return;
  }

  const width = elem.width();
  const height = elem.height();
  const size = [width, height];

  // left top corner of canvas related to viewport
  // (keep in mind that canvas itself is 2000 x 600)
  const LGAP = 200;
  const TGAP = 50;

  const [ex, ey] = [pos.left, pos.top];
  const [cx, cy] = [ex - LGAP, ey - TGAP];

  // изменить положение canvas'а - поближе к месту рисования
  const canvas = $('#my_paper_canvas');

  if (!canvas.offset()) {
    // no diagram should be shown for this page
    return;
  }

  canvas.offset({ top: cy, left: cx });

  const point = [LGAP, TGAP];
  const viewport = {point, size};

  // Отрисовка
  const alg_bbox = redraw_activity_diagram(algorithm_json, existing_trace_json, {viewport});

  // не помогает, только мешает ("ломает" grid)
  // elem.css('height', Math.ceil(alg_bbox.height * 1.3) + 'px');
  // elem.css('width', Math.ceil(alg_bbox.width * 1.1) + 'px');

  const anchor_canvas = [pos.left + width/2 - cx, pos.top - cy];

  // Move canvas along with `diagram_area` DIV when window resizes
  // set / rewrite event listener (warning to other assignments to window.onresize)
  window.onresize = function(..._) {
    // using `elem`, `anchor_canvas`, `canvas` from outer scope
    const pos = elem.offset();
    const width = elem.width();

    const anchor_elem = [pos.left + width/2, pos.top];
    const [ex, ey] = anchor_elem;
    const [cx, cy] = anchor_canvas;

    if (ex != cx || ey != cy) {
      canvas.offset({
        top: ey - cy,
        left: ex - cx
      });
    }
  }

}

export function paper_on_load() {
  console.log("paper_on_load() ...")
  paper_init("my_paper_canvas");
  diagram_init();
  console.log("paper_on_load() OK.")

  // отрисовать диаграмму в первый раз
  draw_diagram();
}

// /paper
