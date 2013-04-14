# Magicio

*[Ma-jih-shee-oh]*

The well-timed revealer. Code to automate cadence-driven actions on words,
phrases and paragraphs on web pages.

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
  $(evt.action.nextElement).addClass('revealed');
}).on('afterbreak', function (evt) {
  $(evt.action.nextElement).addClass('current_paragraph');
}).magicio().magicio('run');
```

By default, *pauses* will be treated as pauses in time and Magicio will keep
going after reaching a pause. *Breaks*, on the other hand, will require the
user to hit any key to continue past the break.

## Options

These can be passed to the `magicio()` plugin method when setting it up.

<table>
  <thead>
    <tr>
      <th>Option</th>
      <th>Default</th>
      <th>Allowed Values</th>
    </tr>
  </thead>
  <tr>
    <td><code>actionOnPause</code></td>
    <td><code>"timeout"</code></td>
    <td><code>"timeout"</code>, <code>"input"</code> (wait for a click/key press)</td>
  </tr>
  <tr>
    <td><code>actionOnBreak</code></td>
    <td><code>"input"</code></td>
    <td><code>"timeout"</code>, <code>"input"</code> (wait for a click/key press)</td>
  </tr>
  <tr>
    <td><code>debug</code></td>
    <td><code>false</code></td>
    <td><code>true</code>, <code>false</code></td>
  </tr>
  <tr>
    <td><code>pauseMilliseconds</code></td>
    <td><code>1000</code></td>
    <td>Any integer value that represents a reasonable number of milliseconds.</td>
  </tr>
</table>

## Events

<table>
  <thead>
    <tr>
      <th>Event Name</th>
      <th>Event Object Contents</th>
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
    <td><code>String</code></td>
    <td>any additional classes that were on the <code>&lt;br /&gt;</code> element (whitespace-separated)</td>
  </tr>
  <tr>
    <td><code>actionType</code></td>
    <td><code>String</code></td>
    <td><code>"pause"</code> or <code>"break"</code></td>
  </tr>
  <tr>
    <td><code>timing</code></td>
    <td><code>Integer</code></td>
    <td>milliseconds to pause for a <code>time</code> action</td>
  </tr>
  <tr>
    <th colspan="3">Methods</th>
  </tr>
  <tr>
    <td><code>eventType()</code></td>
    <td><code>String</code></td>
    <td><code>"timeout"</code> or <code>"input"</code></td>
  </tr>
</table>

## Acknowledgements

The content-wrapping algorithm used for pauses was inspired by [Dave Rupert][DR]
and his wonderful library, [Lettering.js][LJ].

 [DR]: https://twitter.com/davatron5000
 [LJ]: https://github.com/davatron5000/Lettering.js

## Contributing

Yes, I’ll accept pull requests.

 1. **Fork It** - Fork the project under your own user (“Fork” button on github.com)
 2. **Create a Branch** - Create a branch for your fix, e.g. `git checkout -b jd/fix-revealing`
 3. **Push the Branch** - Push your branch to your fork: `git push -u origin jd/fix-revealing`
 4. **Create a Pull Request** - View your branch on github.com; click the “Pull Request” button to ask me to merge into `h3h/master`
