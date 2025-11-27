// =======================================================
// Piccole funzioni di utilità e variabili
// =======================================================

// Costante phi usata per ingrandire i titoli secondo la sezione aurea.
#let phi = 1.618
// Serif principale
#let serif = "Libertinus Serif"
// Sans-serif principale
#let sans-serif = "Libertinus Sans"
// Grigio chiaro
#let light-gray = luma(240)
// Grigio scuro
#let dark-gray = luma(127)
// Colori del tema
#let brand = rgb("#2b5c8a")     // blu istituzionale
#let light-brand = brand.lighten(40%)

// Funzione spacer: crea un box vuoto per aggiungere spaziature verticali/orizzontali.
#let spacer = (w: 0em, h: 1em) => box(outset: (x: w, y: h), " ")

// Funzione per testo stilizzato: centralizza dimensione, peso, font.
#let styled-text = (content, size: 2em, font: sans-serif, weight: "regular", fill: black) => {
  text(
    font: font,
    size: size,
    weight: weight,
    fill: fill,
    hyphenate: false,
    content,
  )
}

// Genera le caption correttamente formattate
#let render-caption(caption) = {
  text(weight: "semibold", font: sans-serif, size: 0.95em, fill: brand)[
    #caption.supplement #caption.counter.display(caption.numbering):
  ]
  text(font: sans-serif, size: 1em)[#caption.body]
}

// Spaziatura della figure rispetto al testo attorno
#let render-float(it, caption-pos: "below", top-inset: 0.75em, bottom-inset: 1.5em) = block(
  above: 1em,
  below: 1em,
  inset: (top: top-inset, bottom: bottom-inset),
  {
    // caption sopra
    if caption-pos == "above" {
      set align(center)
      set par(justify: false)
      render-caption(it.caption)
    }
    
    set align(center)
    it.body
    
    // caption sotto
    if caption-pos == "below" {
      set align(left)
      set par(justify: false)
      render-caption(it.caption)
    }
  },
)

// ========================
// Titolo
// ========================
#let title-block(title: none, subtitle: none, date: none) = {
  align(center, {
    text(size: 2.2em, weight: "bold", font: sans-serif, fill: brand)[#title]
  })

  // linea decorativa sotto al titolo
  box(width: 100%,
      align(center,
        line(length: 5cm, stroke: 1.5pt + brand.lighten(20%)) +
        v(1em)
      )
  )
  
  if subtitle != none {
    v(0.5em)
    align(center, {
      text(size: 1.2em, fill: dark-gray, font: sans-serif)[#subtitle]
    })
  }
  
  if date != none {
    v(1em)
    align(center, {
      text(size: 0.9em, fill: dark-gray, font: sans-serif)[#date]
    })
  }
  
  v(2em)
}

// ========================
// Abstract
// ========================
#let abstract-block(abstract) = {
  text(size: 1.1em, weight: "semibold", font: sans-serif, fill: brand)[In breve]
  v(0.6em)
  set par(justify: true)
  text(font: sans-serif, size: 1em)[#abstract]
  v(2em)
}

// =======================================================
// Intestazioni
// =======================================================
// Tutte le intestazioni usano font sans-serif.
#show heading: set text(font: sans-serif)

// Le intestazioni di livello 1 sono colorate
#show heading.where(level: 1): h => {
  let title-size = 1.5em
  
  block(
    // Evito fine pagina con solo il titolone
    above: title-size * phi,
    below: title-size / phi,
    breakable: false,
    text(
      size: title-size,
      weight: "bold",
      fill: brand,
      font: sans-serif,
      h.numbering + h.body + v(title-size * 0.1))
    )
}



// =======================================================
// Caption di tabelle e figure
// =======================================================
#show figure.where(kind: "quarto-float-fig"): it => render-float(it)
#show figure.where(kind: "image"): it => render-float(it)
#show figure.where(kind: "table"): it => render-float(it, caption-pos: "above", top-inset: 1.5em, bottom-inset: 0.75em)
#show figure.where(kind: "quarto-float-tbl"): it => render-float(
  it,
  caption-pos: "above",
  top-inset: 1.5em,
  bottom-inset: 0.75em,
)

// =======================================================
// Tabelle
// =======================================================
//
// Intestazione della prima riga delle tabelle in grassetto.
#show table.cell.where(y: 0): set text(weight: "bold")
#set table(
  // Riga solo sotto l'intestazione
  stroke: (_, y) => if y == 0 {
    (bottom: 1pt + black)
  } else {
    (bottom: 0.5pt + light-brand)
  },
  // Righe grigie alternate
  fill: (_, y) => if calc.odd(y) { light-gray },
  // Prima colonna a sinistra, le altre centrate
  align: (x, y) => (
    if x > 0 { center } else { left }
  ),
)

// =======================================================
// Blocchi di codice
// =======================================================
#show raw: set block(
  // Sfondo grigio molto chiaro
  fill: light-gray,
  // Padding interno
  inset: 1em,
  // Occupa tutta la larghezza disponibile
  width: 100%,
  stroke: none,
  // Angoli leggermente arrotondat
  radius: 3pt,
)

// =======================================================
// Funzione report() definisce l'intero documento
// =======================================================
#let report(
  title: none,
  subtitle: none,
  date: none,
  lang: none,
  abstract: none,
  content,
) = {
  // Dimensione pagina e margini
  set page(
    paper: "a4",
    margin: (x: 3cm, top: 2.5cm, bottom: 3cm),
    numbering: "1"
  )

  // Titolo e margini
  title-block(title: title, subtitle: subtitle, date: date)
  abstract-block(abstract)

  // Giustificazione
  set par(justify: true)
  // Imposto la lingua e font
  set text(lang: lang, font: sans-serif)
  content
}
