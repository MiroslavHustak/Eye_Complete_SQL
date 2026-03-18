## 5. Popište skript založení stored procedury s výstupním parametrem

V zadání není popsáno, co by mělo byt výstupem, takže výstupem bude dejme tomu počet záznamů (tj. počet lidí) z TabA.

```sql
CREATE PROC GetTabA
    @Count INT OUTPUT -- typová deklarace output parametru
AS
BEGIN 
    SELECT * FROM TabA; -- dostaneme result set, ze kterého níže pomocí COUNT vyselektujeme počet záznamů
    SELECT @Count = COUNT(*) FROM TabA; -- do output parametru dosadíme počet záznamů (tj. počet lidí)
END; -- Konec procedury
```

Použití v SQL kódu:

```sql
DECLARE @output INT;
EXEC GetTabA @Count = @output OUTPUT;
SELECT @output AS PocetZaznamu;
```

---

## 6. Jaký je rozdíl mezi funkcí a stored procedurou s výstupním parametrem?

Funkce v SQL (kromě aggregate functions a window functions) jsou tyto : scalar function (standard SQL), ITVF (standard SQL) - tu jsem už dokonce kdysi použil :-) a MSTVF (T-SQL).
Z povahy dotazu soudím, že máte na mysli scalar function a ne ITVF a MSTVF, které vrací result set (pokud tedy výstupem není side effect) - stejně jako stored procedure bez OUTPUT, která také vrací result set (pokud tedy výstupem není side effect), nepočítám-li status code.

### SCALAR FUNCTION

Scalar function se volá "přímo" v SQL kódu (v SELECT, WHERE, JOIN, ...), např. funkce takto vytvořená `CREATE FUNCTION dbo.AddNumbers (@num1 INT, @num2 INT)...atd.` se volá `SELECT dbo.AddNumbers(5, 3) AS SumResult;` vrací jen jednu hodnotu (skalár).

- Scalar function může být pomalá, protože se `SELECT dbo.AddNumbers(5, 3)` vyhodnocuje pro každý řádek tabulky, a optimalizace dotazu je omezená. Já vím, dnes existuje Scalar UDF Inlining a s pomalostí to nemusí být až tak žhavé, ale to nastuduji, až bude třeba.
- Transaction/rollback/try-catch nelze aplikovat do scalar function.
- Modifikační commands (INSERT INTO, DELETE, UPDATE) nelze použít, neb nelze provést SELECT nad tabulkou, kterou modifikujeme.

### STORED PROCEDURE + OUTPUT PARAMETER

Stored procedure s OUTPUT/OUT parametrem vytvořená takto:

```sql
CREATE PROC Sales.GetCustomerOrders
    @param  AS INT,
    @output AS INT OUTPUT
-- ..atd.
```

...se volá pomocí EXEC, výstup se musí přiřadit, nějak takto:

```sql
DECLARE @output INT;
EXEC Sales.GetCustomerOrders @param = 42, @output = @output OUTPUT;
```

... a musí se dále zpracovat, např. takto:

```sql
SELECT @output AS TotalOrders;
```

- Stored procedure může vracet více hodnot přes více OUTPUT parametrů (nejen skalár jako scalar function), a je rychlejší, než scalar function, neboť se provádí jen jednou.
- Transaction/rollback/try-catch lze aplikovat do stored procedure.
- Modifikační commands (INSERT INTO, DELETE, UPDATE) lze použít, vzhledem k samostatnému volání (EXEC) by neměl být problém.

---

## 7. Jaké jsou druhy triggerů?

**DML triggers:**
- `AFTER` (INSERT INTO, DELETE, UPDATE,...)
- `INSTEAD OF` (nějaké operace)

Osobně jsem si kdysi vyzkoušel jen AFTER (mám to na GitHubu).

**DDL triggers:**
- Pouze `AFTER`, tyto triggers jsem nezkoušel, zatím nevím, kde bych DDL triggers mohl uplatnit.

---

## 8. Jak je uložena SQL DB na disku (většinou)?

| Typ souboru | Přípona |
|-------------|---------|
| primary filegroups (master data files) | `.mdf` |
| secondary filegroups (secondary data files) | `.ndf` |
| transaction log data files | `.ldf` |
| checkpoint files | |

Zatím jsem manipuloval jen s `.mdf` a `.ldf`, s ostatními files ještě ne.

---

## 9. Může být uložena SQL DB ve více souborech nebo jen v jednom souboru?

MS SQL Server umožňuje zápis do více datových souborů najednou (na rozdíl od log files, kde se to zapisuje sekvenčně).

---

## 10. Co je DML? Co je T-SQL?

**DML (Data Manipulation Language)** zahrnuje příkazy pro manipulaci s daty jako INSERT, UPDATE, DELETE, SELECT.

**T-SQL (Transact-SQL)**
T-SQL je standardní SQL rozšířené o další možnosti, případně s upravenými prvky oproti standardnímu SQL (pro použití s MS SQL Server).

Například:

| Standard SQL | T-SQL navíc |
|-------------|-------------|
| `OFFSET-FETCH` | `SELECT TOP` |
| `COALESCE`, `IS NULL` | `ISNULL()` |

Oproti standard SQL jsou v T-SQL navíc features u stringových operací, datových funkcí. Ono učebnice T-SQL, kterou mám, vždy neuvádí rozdíl oproti standard SQL, takže více příkladů rozdílů bych musel pracně hledat jinde (anebo se zeptat LLMka).

---

## 11. Co jsou systémové views? (např. `sys.objects`)

System catalogue views jsou views (je jich hodně) obsahující metadata týkající se dané databáze.

`sys.objects` je jedním z nich — obsahuje metadata uživatelem definovaného prvku (tables, procedures, functions, constraints, triggers) pro všechny objekty v DB nebo jen pro dané schéma, pokud filtrujeme s `WHERE schema_id = SCHEMA_ID('dbo')`.

O system catalogue views jsem teda vůbec nevěděl - může to mít zajímavé použití, viz zadání 1 až 4, anebo třeba:

```sql
SELECT ......, modify_date
FROM sys.objects
WHERE modify_date >= DATEADD(DAY, -30, GETDATE())
ORDER BY modify_date DESC;
```

... a nějak tak principiálně podobně pro další system catalogue views `...FROM sys.views/sys.procedures/sys.tables`.

---

## 12. Co je to GIT?

Git je verzovací systém.

Zatím jsem Git používal jen přes Rust Rover IDE a Visual Studio IDE (ne přes CLI), a to jen pro zálohování kódu (a jednou i pro návrat k fungující verzi, když jsem něco hodně pomotal), nicméně z důvodu absence kolegů jsem branching a merging a další vymoženosti (jako pull request) zatím nepoužíval.

---

## 13. Popište fungování správné práce se zdrojovým kodem ve vazbě na verzování a source control?

No, správně, vím já :-) ... nějaký výplod LLM bych tu nechtěl uvádět, asi bych postupoval nějak takto:

1. Založení REPOSITORY
2. Uložení prvního kódu do MASTER (COMMIT)
3. COMMIT po změnách 
4. Přizvání dalších kolegů do dané repo (alespoň takto je to na GitHubu)
5. Vytvoření BRANCHES pro kolegy
6. Používání PR a issues pro code review
7. Až se kód bude OK zdáti, budeme implementovati MERGE OF BRANCHES INTO MASTER

Ja vím, že v gitu je toho více, než jsem uvedl. Nicméně v případě spolupráce si vyrobím fake project, kde si to ze dvou počítačů vyzkouším a naučím se to, myslím, že jeden den bude stačit.

---

## 14. Jaký je rozdíl mezi klíčovým slovem WHERE a HAVING?

Obojí provádí filtraci, ovšem:

| Klíčové slovo | Filtrace | Umístění | Agregační funkce |
|---------------|----------|----------|-----------------|
| `WHERE` | vztažená k jednotlivým řádkům | před `GROUP BY` | ❌ nelze (jak mne to error messages neustále připomínají :-) ) |
| `HAVING` | vztažená ke grouped rows | za `GROUP BY` | ✅ lze (`SUM`, `COUNT`, `AVG`, atd.) |

---

## 15. Co by mohla ukazovat následující chyba, kde bys ji teoreticky mohl očekávat?

```
Subquery returned more than 1 value. This is not permitted when the subquery follows =, !=, <, <= , >, >= or when the subquery is used as an expression.
```

No, chyba ukazuje na to, co říká anglický originál a osobně jsem se s ní vícekrát setkal ne teoreticky, ale bohužel zcela prakticky.
Mám pocit, že to bylo mj. tady:

```sql
WHERE column = (SELECT something FROM table ...)
```

...ale na ostatní případy si už nevzpomínám. Mám gut feeling, že to asi bylo něco se špatně použitými aggregate functions společně s porovnáváním se se subqueries.

---

## 16. Co dělá tento skript?

Tento skript by měl být používán v kontextu, kdy jsme už použili IDENTITY v CREATE TABLE sometableWithIdentity (společně s PK nebo jiným UNIQUE constraint, abychom zajistili unikátnost), sekvenčnost bude zajištěna automaticky, např. `IDENTITY(1, 1)` - začneme jedničkou s krokem 1, nelze tuto sekvenčnost už měnit, pokud nemáme nastavenou volbu IDENTITY_INSERT jako ON tak, jak je to uvedeno ve Vámi předloženém skriptu.

```sql
SET IDENTITY_INSERT sometableWithIdentity ON -- nastaví volbu IDENTITY_INSERT jako ON (= zapne ji)  
INSERT INTO sometableWithIdentity 
   (IdentityColumn, col2, col3, ...) 
VALUES 
   (AnIdentityValue, col2value, col3value, ...) -- vloží do sloupců dané hodnoty
SET IDENTITY_INSERT sometableWithIdentity OFF -- nastaví volbu IDENTITY_INSERT jako OFF (= vypne ji)  
```

Dle mne je to šikovné v případě, kdy máme "mezeru" pro dané PK IdentityColumn souhlasicí s hodnotou AnIdentityValue, dejme tomu 42 (tj. když máme 1... 40, 41, 43, 44), např. mezeru vzniklou po smazání.

Ale co když míříme ne do mezery, ale do "plné" sekvence? 1...40, 41, 42, 43, 44? Pak constraints (jako např. PK/UNIQUE KEY) tomu zabrání a vyhodí error, to jest takto "insertovat či updatovat" nelze.

Pokud začínáme např. až od 100 a výše (tj. naše 42 je "pod"), tak se command provede, rovnež tak, když míříme "nad" 44, např. 1000, ale dle mne to narušuje sekvenčnost (další bude 101, ne 43, resp. 1001, ne 46) a komplikuje to logiku.

---

## 17. Zkuste popsat co dělá přiložený skript, ideálně řádek po řádku (nebo po smysluplných celcích) 😊

```sql
SET ANSI_NULLS ON
GO
-- První BATCH končí s GO (dle učebnice... GO command is not really a T-SQL command; it's actually a command used by SQLServer's client tools, such as SSMS, to denote the end of a batch)  
-- ANSI_NULLS ON je dnes default a vyžadován např. pro indexed views.  
-- Když je ON (doporučeno), porovnání s NULL pomocí = nebo <> vrací UNKNOWN, tj. musí se používat IS NULL / IS NOT NULL.
```

```sql
SET QUOTED_IDENTIFIER ON
GO
-- Druhý BATCH končí s GO  
-- QUOTED_IDENTIFIER ON je také default.  
-- Při ON: dvojité uvozovky " " → identifikátory (tabulky, sloupce), jednoduché ' ' → string literály.  
-- Při OFF lze dvojité uvozovky použít i pro stringy, což může vést k nejednoznačnosti
```

```sql
create or alter PROCEDURE [dbo].BKOGoPaySmazParovani 
    @intIDHlavickaGoPay int 
AS
-- Vytvoříme novou stored procedure nebo pozměníme existující stored procedure s parametrem @intIDHlavickaGoPay typu integer
-- Na výstupu budu mít, funkcionálně řečeno, side effects (ekvivalent typu unit v F#) a status code.
```

```sql
BEGIN 
-- Každý SQL příkaz běží implicitně v samostatné transakci (autocommit), není zde jedna společná transakce pro celou proceduru.  
-- Neměl být zde být explicitní BEGIN TRANSACTION + COMMIT/ROLLBACK (TRY-CATCH)??? Viděl jsem to v nějakých příkladech.
```

```sql
    SET NOCOUNT ON;
-- Vypne počítání ovlivněných řádků (snižuje síťový traffic, zlepšuje výkon)
```

```sql
    -- declare @intIDHlavickaGoPay int = 15 -- Tohle je commented out, takže jakoby to tady nebylo.
```

```sql
    drop table if exists #tmp_IDs 
    -- Smaže dočasnou tabulku, pokud existuje (# -> lokální temp tabulka -> pouze pro danou session).
```

```sql
    select IDUhradaVypis
    into #tmp_IDs
    from TabBKOGoPayPolozka 
    where IDHlavicka = @intIDHlavickaGoPay 
    -- Do dočasné tabulky #tmp_IDs do sloupce IDUhradaVypis se přidají hodnoty z vyselektovaného result sets, tj. hodnoty z tabulky TabBKOGoPayPolozka při dané podmínce.
    -- Mimochodem, není IDUhradaVypis Foreign_Key (soudě dle poznámky o "zrušení propírování")?
```

```sql
    insert into #tmp_IDs (IDUhradaVypis) 
    select IDUhradaPoplatkyVypis 
    from TabBKOGoPayHlavicka 
    where ID = @intIDHlavickaGoPay and IDUhradaPoplatkyVypis is not null
    -- Do dočasné tabulky #tmp_IDs do sloupce IDUhradaVypis se přidají hodnoty z vyselektovaného result sets, tj. hodnoty ze sloupce IDUhradaPoplatkyVypis tabulky TabBKOGoPayHlavicka při daných podmínkách.
    -- Mimochodem, není IDUhradaPoplatkyVypis Foreign_Key (soudě dle poznámky o "zrušení propírování")?
```

```sql
    update p
    set IDUhradaVypis = null 
    from TabBKOGoPayPolozka p 
    where IDHlavicka = @intIDHlavickaGoPay 
    -- V kódu se provádí UPDATE tabulky TabBKOGoPayPolozka tímto způsobem:  
    -- Nastavení těch hodnot ve sloupci IDUhradaVypis, kde platí daná podmínka, na NULL, přičemž sloupec IDUhradaVypis musí umožňovat NULL (nesmí mít NOT NULL constraint), jinak UPDATE skončí errorem.
    -- Pokud by byl PK, NULL by nebyl povolen vůbec.
```

```sql
    update p 
    set IDUhradaPoplatkyVypis = null
    from TabBKOGoPayHlavicka p 
    where ID = @intIDHlavickaGoPay 
    -- V kódu se provádí UPDATE tabulky tabulky TabBKOGoPayHlavicka tímto způsobem:  
    -- Nastavení těch hodnot ve sloupci IDUhradaPoplatkyVypis, kde platí daná podmínka, na NULL, přičemž sloupec IDUhradaPoplatkyVypis by neměl být NOT NULL, PK, jinak by to skončilo errorem.
```

```sql
    delete from TabBankVypisRUhrady 
    where ID in (select IDUhradaVypis from #tmp_IDs)
-- Smaže hodnoty z tabulky TabBankVypisRUhrady, kde ID leží v množině hodnot mapované pomocí select IDUhradaVypis from #tmp_IDs.
```

```sql
END; 
-- Konec procedury  
-- Bez explicitní transakce je COMMIT samostatně pro každý statement  
-- Při chybě nebude automatický rollback celé procedury, to jest pokud bude error, automatický rollback proběhne jen pro ten příkaz, který selhal – předchozí příkazy zůstanou commitnuté
```
---

## 18. Co je `NEWID()` a `NEWSEQUENTIALID()` – je v těchto funkcích rozdíl?

| Funkce | Popis |
|--------|-------|
| `NEWID()` | Generuje GUIDs s každým řádkem. Hodnoty GUID jsou zcela náhodné. |
| `NEWSEQUENTIALID()` | Generuje GUIDs s každým řádkem. Hodnoty GUID jsou náhodné, ale ne zcela - nové hodnoty jsou větší než předchozí. Je možné takto generované GUID použít místo IDENTITY. |
