
{-
  Dies ist eine verkürzte, veränderte und ergänzte Version von intro.agda,
  die als Grundlage für die Lösung der Aufgaben auf Blatt 2 dienen kann.
  Außerdem kann man hier auch grob den Stand der Vorlesung in Agda sehen.
-}

id : (A : Set) → A → A    -- \to für →
id A = λ x → x            -- \lambda für λ

_∘_ : {A B C : Set} → (B → C) → (A → B) → (A → C)
g ∘ f = λ x → g (f x)

data Bool : Set where
  true : Bool
  false : Bool

not : Bool → Bool
not true = false
not false = true

data ℕ : Set where    -- \bN für ℕ
  O : ℕ
  S : ℕ → ℕ

_+_ : ℕ → ℕ → ℕ
O + k = k
S n + k = S (n + k)


data 𝟙 : Set where
  ∗ : 𝟙

data ∅ : Set where   -- \emptyset für ∅

-- Das Koprodukt aus der VL
data _⊔_ (A B : Set) : Set where    -- \sqcup für ⊔
  ι₁ : A → A ⊔ B
  ι₂ : B → A ⊔ B

data _≈_ {A : Set} : A → A → Set where   -- \~~ oder \approx für ≈
  refl : {x : A} → x ≈ x                 -- Abhängigkeit von Termen wird durch "A → A → Set" realisiert
                                         -- "{...}" lassen Agda das Argument ("x" und "A") berechnen.

≈𝟙 : (x : 𝟙) → x ≈ ∗
≈𝟙 ∗ = refl

≈⊔ : (x : Bool) → (x ≈ true) ⊔ (x ≈ false)
≈⊔ true = ι₁ refl
≈⊔ false = ι₂ refl

isProp∅ : (x y : ∅) → x ≈ y
isProp∅ ()

_⁻¹ : {A : Set} {x y : A} → x ≈ y → y ≈ x   -- \^-\^1 für ⁻¹
refl ⁻¹ = refl

_∙_ : {A : Set} {x y z : A} → x ≈ y → y ≈ z → x ≈ z
refl ∙ refl = refl
infixr 21 _∙_                                         -- Priorität für _∙_ höher als ≈
                                                      -- (festlegen auf rechtsassoziativität)

assoc : {A : Set} {x y z u : A} (γ : x ≈ y) (η : y ≈ z) (ι : z ≈ u) → γ ∙ (η ∙ ι) ≈ (γ ∙ η) ∙ ι
assoc refl refl refl = refl

ap : {A B : Set} {x y : A} (f : A → B) → x ≈ y → f x ≈ f y
ap f refl = refl

infix 21 _+_ -- priorität von + sollte höher als die der Gleichheit sein
n+0≈n : (n : ℕ) → n + O ≈ n
n+0≈n O = refl
n+0≈n (S n) = ap S (n+0≈n n)

n+k≈k+n : (n k : ℕ) → n + k ≈ k + n
n+k≈k+n O k = (n+0≈n k) ⁻¹
n+k≈k+n (S n) k = ap S (n+k≈k+n n k) ∙ lemma k n
  where
  lemma : (n k : ℕ) → S(n + k) ≈ n + S k
  lemma O k = refl
  lemma (S n) k = ap S (lemma n k)

refl-linksneutral : {A : Set} {x y : A} (p : x ≈ y) → refl ∙ p ≈ p
refl-linksneutral refl = refl

refl-rechtsneutral : {A : Set} {x y : A} (p : x ≈ y) → p ∙ refl ≈ p
refl-rechtsneutral refl = refl

∙-linksinvers : {A : Set} {x y : A} (p : x ≈ y) → p ⁻¹ ∙ p ≈ refl
∙-linksinvers refl = refl

-- transport
tr : {A : Set} {x y : A} (B : A → Set) (p : x ≈ y) → B(x) → B(y)
tr B (refl {x = x}) = id (B(x))                                  -- s.u.
{-
  wenn man doch mal ein Argument angeben möchte, das man mit {...}
  für implizit erklärt hat, kann man das z.B. mit {x = x} machen.
  Das linke "x" ist hier der Name aus der definition von "refl".
-}

infixr 21 _∘_

tr-functorial : {A : Set} {x y z : A} (B : A → Set) (p : x ≈ y) (q : y ≈ z)
                → tr B q ∘ tr B p ≈ tr B (p ∙ q)                             -- Zeilenumbrüche sind ok
tr-functorial B refl refl = refl

infix 22 _⁻¹   -- Inversion sollte höhere Priorität als ∙ haben
-- dieses Beispiel funktioniert nur, weil wir hier ∙ entsprechend definiert haben
tr-l≈ : {A : Set} (y₀ : A) {u v : A} (p : u ≈ v) (q : u ≈ y₀)
        → tr (λ x → x ≈ y₀) p q ≈ p ⁻¹ ∙ q
tr-l≈ y₀ refl refl = refl

tr-r≈ : {A : Set} (x₀ : A) {u v : A} (p : u ≈ v) (q : x₀ ≈ u)
        → tr (λ y → x₀ ≈ y) p q ≈ (q ∙ p)
tr-r≈ = {!!}

data Σ (A : Set) (B : A → Set) : Set where
  _,_ : (x : A) (y : B x) → Σ A B

ex-ℕ : (x : ℕ) → (x ≈ O) ⊔ (Σ ℕ (λ y → x ≈ S y))
ex-ℕ O = ι₁ refl
ex-ℕ (S x) = ι₂ (x , refl)

is-contr : (A : Set) → Set
is-contr A = Σ A (λ (x : A) → (y : A) → y ≈ x)

Σ-≈ : {A : Set} {B : A → Set} {x y : A} {u : B x} {v : B y}
      → Σ (x ≈ y) (λ p → tr B p u ≈ v) → (x , u) ≈ (y , v)
Σ-≈ (refl , refl) = refl

lemma-Σ-≈ : (A : Set) (x : A) → is-contr (Σ A (λ y → y ≈ x))
lemma-Σ-≈ A x = (x , refl) , helper
  where
    helper : (z : Σ A (λ y → y ≈ x)) → z ≈ (x , refl)
    helper (y , p) = Σ-≈ (p , (tr-l≈ _ p p ∙ ∙-linksinvers p))
