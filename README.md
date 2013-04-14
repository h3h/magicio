# Magicio

*[Ma-jih-shee-oh]*

The well-timed revealer. Code to automate cadence-driven actions in web browser UIs.

## Usage

First, mark up your HTML with the pauses and breaks you want to use:

```html
<section id="mytext">
  <p class="m-break">
    Bacon ipsum dolor sit amet sirloin swine brisket jowl ham,
    <br class="m-pause" />
    leberkas beef ribs chicken.
  </p>

  <p class="m-break">
    Sausage capicola chuck shoulder drumstick pork. Tail salami turducken biltong
    pig prosciutto strip steak pancetta tongue sausage ham hock hamburger.
    <br class="m-pause m-timing-500" />
    Ham hock boudin pork loin bacon, ribeye ball tip doner
    hamburger chicken short ribs prosciutto. Venison filet mignon capicola, ball
    tip andouille corned beef doner spare ribs turducken ham hock drumstick
    bresaola sirloin brisket. Meatloaf rump frankfurter, sirloin tail beef ribs
    sausage chuck fatback.
  </p>
</section>
```

Then set up Magicio to control that block, set up some listeners for post-pause
and post-break events and tell Magicio to start running:

```javascript
$("#mytext").on('afterpause', function (evt) {
  $(evt.action.prevelemEnt).addClass('seen');
}).on('afterbreak', function (evt) {
  $(evt.action.prevelemEnt).css({opacity: 0});
}).magicio().magicio('run');
```

By default, *pauses* will be treated as pauses in time and Magicio will keep
going after reaching a pause. *Breaks*, on the other hand, will require the
user to hit any key to continue past the break.

## Events

<table>
  <thead>
    <tr>
      <th>Event Name</th>
      <th><code>event.data</code> Contents</th>
    </tr>
  </thead>
  <tr>
    <td><code>beforeparse</code></td>
    <td></td>
  </tr>
  <tr>
    <td><code>afterparse</code></td>
    <td><code>{actors: [jQuery&lt;Element&gt;]}</code></td>
  </tr>
  <tr>
    <td><code>beforerun</code></td>
    <td><code>{actions: [Array&lt;Action&gt;]}</code></td>
  </tr>
  <tr>
    <td><code>beforepause</code></td>
    <td><code>{action: [Action]}</code></td>
  </tr>
  <tr>
    <td><code>afterpause</code></td>
    <td><code>{action: [Action]}</code></td>
  </tr>
  <tr>
    <td><code>beforebreak</code></td>
    <td><code>{action: [Action]}</code></td>
  </tr>
  <tr>
    <td><code>afterbreak</code></td>
    <td><code>{action: [Action]}</code></td>
  </tr>
  <tr>
    <td><code>afterrun</code></td>
    <td><code>{actions: [Array&lt;Action&gt;]}</code></td>
  </tr>
  <tr>
</table>

## Classes

<h3><code>Action</code></h3>

<table>
  <tr>
    <th colspan="3">Attributes</th>
  </tr>
  <tr>
    <td><code>nextElement</code></td>
    <td><code>jQuery&lt;Element&gt;</code></td>
    <td>the actor element immediately preceeding the action</td>
  </tr>
  <tr>
    <td><code>prevElement</code></td>
    <td><code>jQuery&lt;Element&gt;</code></td>
    <td>the actor element immediately succeeding the action</td>
  </tr>
  <tr>
    <td><code>actionClasses</code></td>
    <td><code>Array&lt;String&gt;</code></td>
    <td>any additional classes that were on the <code>&lt;br /&gt;</code> element</td>
  </tr>
  <tr>
    <td><code>actionType</code></td>
    <td><code>String</code></td>
    <td><code>"time"</code> or <code>"action"</code></td>
  </tr>
  <tr>
    <td><code>timing</code></td>
    <td><code>Integer</code></td>
    <td>milliseconds to pause for a <code>time</code> action</td>
  </tr>
</table>
