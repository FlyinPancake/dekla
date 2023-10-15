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

Az első nagy házi feladat a `satrak/1` függvény megírása. A függvény specifikációja a következő:
#figure(caption: "A `satrak/1` függvény specifikációja", kind: "code", supplement: "Kód")[
```elixir
  @spec satrak(pd::puzzle_desc) :: tss::[tent_dirs]
```
]
A feladatkiírás részeként a következő típusspecifikációkat kapjuk:

#figure(caption: "Típusdefiníciók", kind: "code", supplement: "Kód")[
```elixir
# sor száma (1-től n-ig)
@type row :: integer
# oszlop száma (1-től m-ig)
@type col :: integer
# egy parcella koordinátái
@type field :: {row, col}

# a sátrak száma soronként
@type tents_count_rows :: [integer]
# a sátrak száma oszloponként
@type tents_count_cols :: [integer]

# a fákat tartalmazó parcellák koordinátái lexikálisan rendezve
@type trees :: [field]
# a feladványleíró hármas
@type puzzle_desc :: {tents_count_rows, tents_count_cols, trees}

# a sátorpozíciók iránya: north, east, south, west
@type dir :: :n | :e | :s | :w
# a sátorpozíciók irányának listája a fákhoz képest
@type tent_dirs :: [dir]
```
]

= A feladat megoldása

== Tervezés

A program backtrack algoritmust használ a helyes megoldások megkeresésére.
Kimerítően végigpróbálja az összes lehetőséget, egészen addig, amíg lehetetlen helyzetne nem ütközik.
Ehez szükséges tudni, hogy mikor "rontjuk el" a feladványt.
Minden "lépés" egy sátor lehelyezése a következő fa mellé. 
A program nem optimalizál a fák kiválasztásával, mindig a sorban követkeőt választja.

A kemping modellezésére egy `grid` típust vezettem be, ami `field_kind`-ok listájának listája.
A `field_kind` típus a következő atomok egyike lehet: `:tree`, `:tent`, `:empty`.
```ex
@type field_kind :: :tree | :tent | :empty
@type row_fields :: [field_kind]
@type grid :: [row_fields]
```

Ezekkel érthetően leírható a kemping állapota.
Ezeken, és a sablonban meghatározott típusokon kívül mást nem használtam a programban. 

== Implementáció
 
Mivel minden sátor lehelyezésével potenciálisan megoldhatatlan helyzetbe kerülünk, ezért a programnak tudnia kell, hova helyezhet sátrat. 
Erre készítettem az `is_valid_tent_position/5` függvényt.
#figure(caption: "A `is_valid_tent_position/5` függvény specifikációja", kind: "code", supplement: "Kód")[
```elixir
@spec is_valid_tent_position(
       grid :: grid,
       row :: row,
       col :: col,
       tents_count_rows :: tents_count_rows,
       tents_count_cols :: tents_count_cols
) :: boolean
```
]

A függvény a következőképpen működik:
1. Megnézi, hogy a parcella, amire sátrat szeretnénk tenni, üres-e.
2. Megnézi, hogy a parcella, amire a sátrat tennénk, érintkezik-e már lerakott sátorral.
3. Ellenőrzi, hogy a sátor lehelyezésével nem sérülnek-e a sor- és oszlopkövetelmények.

A függvényt minden fa melletti, kempingmezőn meghívjuk és amelyekre igazat ad vissza, azokkal folytatjuk a megoldás keresését.
Ez a hívás a `find_tent_configs/5` függvényben történik, ami rekurzívan hívja újra önmagát a jónak bizonyult sátorpozíciókkal.
A nyelv sajátossága miatt a ha egy megoldhatatlan állapotban vagyunk, akkor a for komprehensió miatt egy üres megoldáslistát ad vissza a függvény.

A `find_tent_configs/5` függvény specifikációja a következő:
#figure(caption: "A `find_tent_configs/5` függvény specifikációja", kind: "code", supplement: "Kód")[
```elixir
@spec find_tent_configs(
          grid :: grid,
          trees :: trees,
          tent_positions :: tent_dirs,
          tents_count_rows :: tents_count_rows,
          tents_count_cols :: tents_count_cols
) :: [tent_dirs]
```
]

Mint látható a függvény specifikációja a visszatérési típusán kívül megegyezik az `is_valid_tent_position/5`-el.

A függvény először a kilépési feltételt vizsgálja, hogy a sátrak száma megegyezik-e a fák számával.
Ekkor a függvény ellenőrzi a sor- és oszlopkövetelményeket, ha azok teljesülnek, akkor a sátorpozíciók listáját adja vissza.

Az egyetlen komplikáció a függvényben a sátorpozíciók listájának visszaadása.
Erre a következő megoldást találtam ki:
#figure(caption: "A sátorirányok visszaadása", kind: "code", supplement: "Kód")[
```elixir
for dir <- valid_dirs do
        find_tent_configs(
          populated_grid,
          trees,
          tent_positions ++ [dir],
          tents_count_rows,
          tents_count_cols
        )
      end
      |> Enum.flat_map(& &1)
```
]
Itt látható az `Enum.flat_map/2` függvény használata, amivel a rekurzív hívások eredményeit egy listába gyűjtjük.

== Tesztelés

Mivel a félév során az összes órai munkát Livebook-ban, a házi feladatot pedig Mix projektekben készítettem,
egyértelmű volt, hogy a nagy házi feladatot is az ExUnit keretrendszerrel fogom tesztelni.

A feladatkiírásban található példák alapján készítettem teszteket.
A tesztek a következőképpen néznek ki:
#figure(caption: "Tesztek", kind: "code", supplement: "Kód")[
```elixir
  test "Sanity" do
    assert Nhf1.satrak({[0, 2, 0], [1, 0, 1], [{1, 1}, {1, 3}]}) == [[:s, :s]]
  end

  test "Case 1" do
    assert Nhf1.satrak(
             {[1, 1, 0, 3, 0], [1, 0, 2, 0, 2], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]}
           ) === [[:e, :s, :n, :n, :n]]
  end

  test "Case 2" do
    assert Nhf1.satrak(
             {[-1, -1, -1, 3, 0], [-1, -2, -2, 0, -2], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]}
           ) ===
             [[:w, :s, :n, :n, :n], [:s, :s, :n, :n, :n], [:e, :s, :n, :n, :n]]
  end
  ```
]
A tesztek között szerpel egy `Sanity` nevű teszt is, ami egy triviális feladványt tesztel.
Ezt a tesztet a programozás során használtam, hogy ellenőrizzem, hogy a programom helyesen működik-e.

Az első beadás után a tesztesteket kibővítettem az ETS-en elérhető feladványokkal.
Az Elixir támogat REPL környezetet is, de ez véleményem szerint nagyban lassítja a fejlesztést.

== Hibakeresés

A programozás során több hibával is találkoztam.
A leggyakoribb hibák között természetesen szerepeltek a szintaktikai hibák, amiket a fordító jelzett,
off-by-one hibák, amiket a tesztekkel találtam meg (leggyakrabban `- 1`-ek elmaradtak, vagy nem voltak szükségesek).
A legérdekesebb azonban egy olyan hiba volt, amikor az Elixir a `- 1`-et `-1` nek értelmezte, és nem talált operandust a két szám között.

== Tapasztalatok

A program futási ideje a saját számítógépemen 0.5 másodperc volt. 5 példa esetén és kb. 1 másodperc az ETS szerveren.
A program futási idejét lehetséges, hogy befolyásolja hogy egy helyen a `++` operátort használtam, ami nem hatékony.