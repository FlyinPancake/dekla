#set par(leading: 0.55em, first-line-indent: 1.8em, justify: true)
// #show par: set block(spacing: 0.55em)
#set text(font: "Times New Roman", size: 12pt)
#set text(lang: "hu")
#show heading.where(level:1): set text(size: 24pt) 
#show heading: set block(above: 1.4em, below: 1em)
#set page(
    paper: "a4",
    margin: 3cm
)

#let today = datetime.today()
#let show_today = today.display("[year]-[month repr:long]-[day].")
#let months_hu = ("január", "február", "március", "április", "május", "június", "július", "augusztus", "szeptember", "október", "november", "december")
#let show_today_hu = [#today.year(). #months_hu.at(today.month() - 1) #today.day().]

#align(center, text(size: 20pt,[Deklaratív Programozás 1. Nagy házi feldat]))
#v(2cm)
#align(center, text(size: 24pt, [Sátrak]))
#set page(numbering: "1")
#pagebreak()
#outline(title: "Tartalomjegyzék", depth: 2)
#v(1fr)
#bibliography("bibliography.yaml", title: "Irodalomjegyzék")
#set heading(numbering: "1.1.1.1")
#show heading.where(level:1): it => [
    #pagebreak()
    #text(size: 14pt)[#counter(heading).display(it.numbering). fejezet]\
    #v(0.5em)\
    #it.body
]
= A sátrak feladvány

Egy téglalap alakú kemping négyzet alakú, egyforma parcellákra van felosztva. Kezdetben a parcellák többsége üres, egyes parcellákon egy-egy fa áll. Az üres parcellákon – egy-egy szomszédos fához kötve – sátrakat állíthatunk fel, az alábbi feltételekkel:

1. egy parcellán legfeljebb egy fa vagy egy sátor lehet,
2. minden fához pontosan egy sátrat kell kötni, és minden sátor pontosan egy fához van kötve,
3. egy sátor akkor köthető egy fához, ha a parcellák, amelyeken állnak, oldalszomszédok,
4. olyan parcellák, amelyeken sátrak állnak, sem oldal-, sem sarokszomszédok nem lehetnek, azaz egy sátor nem érinthet egyetlen másik sátrat sem.

Összesen $n*m$ parcella van a kempingben (hosszában $n$, széltében $m$). Ismerjük a fák pontos helyét, továbbá a sátrak számát soronként és oszloponként. A fát, amelyhez a sátor hozzá van kötve, a sátor saját fájának nevezzük. Meghatározandó a sátrak helyzete a saját fájukhoz képest. Az alábbi példákban a fákat F-fel, a sátrakat S-sel jelöljük.#cite("dekla")
#v(1fr)

#stack(dir: ltr, spacing: 1fr,
    
    
figure(caption: "Egy feladvány (n=5, m=5)", kind: "image", supplement: "Ábra")[
```
        1 --------> m

         1  0  2  0  2 
       ·--·--·--·--·--·
1    1 |  |F |  |  |  |
       ·--·--·--·--·--·
|    1 |  |  |  |  |  |
|      ·--·--·--·--·--·
|    0 |  |  |F |  |F |
|      ·--·--·--·--·--·
v    3 |  |  |  |  |  |
       ·--·--·--·--·--·
n    0 |F |  |  |  |F |
       ·--·--·--·--·--·
```
]
,
figure(caption: "Egy feladvány (n=5, m=5)", kind: "image", supplement: "Ábra")[
```
        1 --------> m

         1  0  2  0  2 
       ·--·--·--·--·--·
1    1 |  |F |  |  |  |
       ·--·--·--·--·--·
|    1 |  |  |  |  |  |
|      ·--·--·--·--·--·
|    0 |  |  |F |  |F |
|      ·--·--·--·--·--·
v    3 |  |  |  |  |  |
       ·--·--·--·--·--·
n    0 |F |  |  |  |F |
       ·--·--·--·--·--·
```
]
)
#v(1fr)
#pagebreak()

Előfordulhat, hogy egyes sorokban, ill. oszlopokban nem írjuk elő a sátrak számát: ezt a megfelelő sor, ill. oszlop elején álló negatív szám jelzi. Példa:

#figure(caption: "Egy feladvány (n=5, m=5)", kind: "image", supplement: "Ábra")[
```
         1 --------> m

         1  0 -1  0  2 
       ·--·--·--·--·--·
1    1 |  |F |  |  |  |
       ·--·--·--·--·--·
|    1 |  |  |  |  |  |
|      ·--·--·--·--·--·
|   -2 |  |  |F |  |F |
|      ·--·--·--·--·--·
v    3 |  |  |  |  |  |
       ·--·--·--·--·--·
n    0 |F |  |  |  |F |
       ·--·--·--·--·--·
```
]

== A házi feladat

Az első nagy házi feladat a `satrak/1` függvény megírása.