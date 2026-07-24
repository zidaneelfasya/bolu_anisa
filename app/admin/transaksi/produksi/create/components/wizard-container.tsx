"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Step1Info } from "./step1-info";
import { Step2Bahan } from "./step2-bahan";
import { Step3Packaging } from "./step3-packaging";
import { Step4Hasil } from "./step4-hasil";
import { Step5Ringkasan } from "./step5-ringkasan";
import { useProduksi } from "../context/produksi-context";
import { submitProduksi } from "../actions";
import { toast } from "sonner";
import { useRouter } from "next/navigation";

const STEPS = [
  "Informasi",
  "Bahan Baku",
  "Packaging",
  "Hasil",
  "Ringkasan"
];

export function WizardContainer() {
  const [currentStep, setCurrentStep] = useState(1);
  const [isSubmitting, setIsSubmitting] = useState(false);
  
  const { info, bahanBaku, packaging, hasil } = useProduksi();
  const router = useRouter();

  const handleNext = () => {
    if (currentStep < 5) setCurrentStep(currentStep + 1);
  };

  const handlePrev = () => {
    if (currentStep > 1) setCurrentStep(currentStep - 1);
  };

  const handleSave = async () => {
    if (bahanBaku.length === 0 || hasil.length === 0) {
      toast.error("Minimal harus ada 1 Bahan Baku dan 1 Hasil Produksi.");
      return;
    }

    setIsSubmitting(true);
    const payload = { info, bahanBaku, packaging, hasil };
    
    const result = await submitProduksi(payload);
    
    if (result.error) {
      toast.error(result.error);
      setIsSubmitting(false);
    } else {
      toast.success("Produksi berhasil diselesaikan!");
      // Redirect ke halaman history/list produksi
      router.push("/admin/transaksi/produksi");
    }
  };

  return (
    <Card className="border-t-4 border-t-primary shadow-lg">
      <CardContent className="p-6">
        {/* Progress Bar & Tabs */}
        <div className="mb-8">
          <div className="flex justify-between items-center mb-2">
            {STEPS.map((stepName, idx) => {
              const stepNumber = idx + 1;
              const isActive = stepNumber === currentStep;
              const isPassed = stepNumber < currentStep;
              
              return (
                <div key={idx} className="flex flex-col items-center relative z-10">
                  <div 
                    className={`h-8 w-8 rounded-full flex items-center justify-center font-bold text-sm border-2 transition-colors
                      ${isActive ? 'bg-primary border-primary text-primary-foreground' : 
                        isPassed ? 'bg-primary/20 border-primary text-primary' : 
                        'bg-muted border-muted text-muted-foreground'}`}
                  >
                    {stepNumber}
                  </div>
                  <span className={`text-xs mt-2 font-medium hidden md:block
                    ${isActive ? 'text-foreground' : 'text-muted-foreground'}`}>
                    {stepName}
                  </span>
                </div>
              );
            })}
            
            {/* Connecting line */}
            <div className="absolute left-6 right-6 top-[40px] md:top-[44px] h-[2px] bg-muted -z-10 px-8">
               <div 
                 className="h-full bg-primary transition-all duration-300" 
                 style={{ width: `${((currentStep - 1) / 4) * 100}%` }}
               />
            </div>
          </div>
        </div>

        {/* Content Area */}
        <div className="min-h-[400px] py-4">
          {currentStep === 1 && <Step1Info />}
          {currentStep === 2 && <Step2Bahan />}
          {currentStep === 3 && <Step3Packaging />}
          {currentStep === 4 && <Step4Hasil />}
          {currentStep === 5 && <Step5Ringkasan />}
        </div>

        {/* Navigation Buttons */}
        <div className="flex justify-between mt-8 pt-4 border-t">
          <Button 
            variant="outline" 
            onClick={handlePrev}
            disabled={currentStep === 1 || isSubmitting}
          >
            Kembali
          </Button>
          
          {currentStep < 5 ? (
            <Button onClick={handleNext} className="bg-primary hover:bg-primary/90" disabled={isSubmitting}>
              Selanjutnya
            </Button>
          ) : (
            <Button 
              className="bg-green-600 hover:bg-green-700 text-white" 
              onClick={handleSave}
              disabled={isSubmitting}
            >
              {isSubmitting ? "Menyimpan..." : "Simpan Produksi"}
            </Button>
          )}
        </div>
      </CardContent>
    </Card>
  );
}
