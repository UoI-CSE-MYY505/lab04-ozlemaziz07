.globl str_ge, recCheck

.data

maria:    .string "Maria"
markos:   .string "Markos"
marios:   .string "Marios"
marianna: .string "Marianna"

.align 4

arraySorted:    .word maria, marianna, marios, markos
arrayNotSorted: .word marianna, markos, maria

.text

main:
            la   a0, arrayNotSorted
            li   a1, 3              # Θέσε το μέγεθος του πίνακα
            jal  recCheck

            li   a7, 10
            ecall

# Υπορουτίνα str_ge για τη σύγκριση δύο strings
# a0: Διεύθυνση string 1
# a1: Διεύθυνση string 2
str_ge:
            lbu  t0, 0(a0)          # Φόρτωσε τον χαρακτήρα από το string 1
            lbu  t1, 0(a1)          # Φόρτωσε τον χαρακτήρα από το string 2
            sub  t2, t0, t1         # Υπολόγισε τη διαφορά των δύο χαρακτήρων
            addi a0, a0, 1          # Προχώρησε στον επόμενο χαρακτήρα του string 1
            addi a1, a1, 1          # Προχώρησε στον επόμενο χαρακτήρα του string 2
            add  t3, t1, t0         # Έλεγχος για τερματιστικό χαρακτήρα (null)
            beq  t3, t0, ret_strcmp # Αν τελείωσε το string, πήγαινε στην επιστροφή

            beq  t2, zero, str_ge   # Αν οι χαρακτήρες είναι ίσοι, συνέχισε στον βρόχο

ret_strcmp:
            srli a0, t2, 31         # Ανάκτηση του bit του πρόσημου (0 ή 1)
            xori a0, a0, 1          # Αναστροφή, ώστε 1 σημαίνει "μεγαλύτερο ή ίσο"
            jr   ra                 # Επιστροφή

# Υπορουτίνα recCheck για τον έλεγχο ταξινόμησης πίνακα strings
# a0: Διεύθυνση πίνακα strings
# a1: Μέγεθος του πίνακα
recCheck:
            slti t0, a1, 2          # Αν size < 2, ο πίνακας είναι ταξινομημένος
            beq  t0, zero, checkFirstTwo
            li   a0, 1              # Επιστροφή 1 αν είναι ταξινομημένος
            jr   ra

checkFirstTwo:
            addi sp, sp, -12        # Επέκταση της στοίβας για την αποθήκευση καταχωρητών
            sw   ra, 8(sp)
            sw   a0, 4(sp)
            sw   a1, 0(sp)

            lw   a1, 0(a0)          # Φόρτωσε το πρώτο στοιχείο του πίνακα
            lw   a0, 4(a0)          # Φόρτωσε το δεύτερο στοιχείο του πίνακα
            jal  str_ge             # Κάλεσε τη str_ge για σύγκριση

            beq  a0, zero, return   # Αν δεν είναι ταξινομημένα, επέστρεψε 0

            # Επανάκληση της recCheck για το υπόλοιπο του πίνακα
            lw   a0, 4(sp)          # Επαναφορά της αρχικής διεύθυνσης του πίνακα
            lw   a1, 0(sp)          # Επαναφορά του αρχικού μεγέθους του πίνακα
            addi a0, a0, 4          # Μετάβαση στο επόμενο στοιχείο του πίνακα
            addi a1, a1, -1         # Μείωση του μεγέθους κατά 1
            jal  recCheck           # Αναδρομική κλήση

return:
            lw   ra, 8(sp)          # Επαναφορά του καταχωρητή επιστροφής
            addi sp, sp, 12         # Αποδέσμευση χώρου στη στοίβα
            jr   ra                 # Επιστροφή στην κλήση

 