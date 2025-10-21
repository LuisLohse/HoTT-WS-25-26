
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
refl ∙ γ = γ
infixr 21 _∙_                                         -- Priorität für _∙_ höher als ≈
                                                      -- (festlegen auf rechtsassoziativität)

assoc : {A : Set} {x y z u : A} (γ : x ≈ y) (η : y ≈ z) (ι : z ≈ u) → γ ∙ (η ∙ ι) ≈ (γ ∙ η) ∙ ι
assoc refl η ι = refl

ap : {A B : Set} {x y : A} (f : A → B) → x ≈ y → f x ≈ f y
ap f refl = refl

infixr 22 _+_ -- priorität von + sollte höher als die der Gleichheit sein
n+0≈n : (n : ℕ) → n + O ≈ n
n+0≈n O = refl
n+0≈n (S n) = ap S (n+0≈n n)

{-
n+k≈k+n : (n k : ℕ) → n + k ≈ k + n
n+k≈k+n O k = n+0≈n k ⁻¹
n+k≈k+n (S n) k = {!!}
-}
