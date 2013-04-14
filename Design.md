# Parsing Details

Block-level elements for breaks; `br` elements for pauses.

## Before Parsing

    <section>
        <p class="m-break">
            Bacon ipsum dolor sit amet sirloin swine brisket jowl ham,
            <br class="m-pause" />
            leberkas beef ribs chicken.
        </p>
        <p class="m-break">
            Sausage capicola chuck shoulder drumstick pork.
            <br class="m-pause other-class-here" />
            Tail salami turducken biltong pig prosciutto strip steak pancetta
            tongue sausage ham hock hamburger.
        </p>
    </section>

## After Parsing

    <section>
        <p class="m-break m-break-parsed">
            <span class="m-pause-parsed">Bacon ipsum dolor sit amet sirloin
            swine brisket jowl ham,</span>
            <span class="m-pause-parsed">leberkas beef ribs chicken.</span>
        </p>
        <p class="m-break m-break-parsed">
            <span class="m-pause-parsed">Sausage capicola chuck shoulder drumstick pork.</span>
            <span class="m-pause-parsed other-class-here">Tail salami turducken biltong pig
            prosciutto strip steak pancetta tongue sausage ham hock hamburger.</span>
        </p>
    </section>
